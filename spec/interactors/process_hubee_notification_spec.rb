require "rails_helper"

RSpec.describe ProcessHubEENotification, type: :interactor do
  subject(:interactor) { described_class.call(notification: notification_hash) }

  let(:action_type) { "STATUS_UPDATE" }
  let(:event_id) { "5678" }
  let(:event_status) { "SENT" }
  let(:notification_hash) do
    {
      "caseId" => "1234",
      "eventId" => event_id,
      "processCode" => process_code,
      "id" => "abcd",
    }
  end
  let(:process_code) { "FormulaireQF" }

  describe ".call" do
    let(:event_payload) do
      {
        "actionType" => action_type,
        "attachments" => [],
        "author" => "John Doe",
        "caseCurrentStatus" => "SENT",
        "caseNewStatus" => status,
        "comment" => "",
        "createDateTime" => "2024-07-04T08:54:15.438+00:00",
        "id" => "905055ea-ed37-4556-9db6-97ba89fcb91f",
        "message" => "",
        "notification" => true,
        "partnerAttributes" => nil,
        "partnerInfo" => {
          "editorName" => "SOMEEDITOR",
          "applicationName" => "Portail",
          "softwareVersion" => "2.2.2",
        },
        "status" => event_status,
        "transmitter" => {
          "type" => "SI",
          "branchCode" => "04107",
          "companyRegister" => "21040107100019",
        },
        "updateDateTime" => nil,
      }
    end
    let(:event_response) { instance_double(HubEE::Api::Response, body: event_payload) }
    let(:session) { instance_double(HubEE::Api) }
    let(:status) { "SI_RECEIVED" }

    before do
      allow(HubEE::Api).to receive(:session).and_return(session)
      allow(session).to receive(:event).and_return(event_response)
      allow(session).to receive(:update_event)
      allow(session).to receive(:delete_notification)
    end

    shared_examples "an ignored notification" do
      it "deletes the notification" do
        expect(session).to receive(:delete_notification)
        interactor
      end

      it "does not update the event" do
        expect(session).not_to receive(:update_event)
        interactor
      end
    end

    context "when the notification is for FormulaireQF" do
      context "when the notification is for an existing folder" do
        context "when the event is fetch correctly" do
          context "when the event is sent" do
            context "when the event is a status update" do
              let!(:shipment) { create(:shipment, hubee_case_id: case_id) }

              let(:case_id) { "1234" }

              it "update the hubee event" do
                expect(session).to receive(:update_event)
                interactor
              end

              context "when the event is processable" do
                it "deletes the notification" do
                  expect(session).to receive(:delete_notification)
                  interactor
                end

                context "when there is a matching shipment" do
                  it "updates the shipment status" do
                    expect { interactor }.to change { shipment.reload.hubee_status }.to("si_received")
                  end

                  context "when the event is a final status" do
                    let(:status) { "DONE" }

                    before do
                      allow(session).to receive(:close_case)
                      allow(session).to receive(:create_event)
                      allow(session).to receive(:close_folder)
                    end

                    it "erases the folder id and keeps the case id" do
                      expect {
                        interactor
                        shipment.reload
                      }.to change { shipment.hubee_folder_id }.to(nil)
                        .and not_change { shipment.hubee_case_id }
                    end

                    it "closes the folder" do
                      expect(session).to receive(:close_case)
                      expect(session).to receive(:create_event)
                      expect(session).to receive(:close_folder)
                      interactor
                    end

                    context "when HubEE fails while closing the case" do
                      before do
                        attempts = 0
                        allow(session).to receive(:close_case) do
                          attempts += 1
                          raise HubEE::Api::Error, "HubEE unreachable on PATCH" if attempts == 1
                        end
                      end

                      it "closes the case and the folder on the retry" do
                        expect { described_class.call(notification: notification_hash) }.to raise_error(HubEE::Api::Error)
                        described_class.call(notification: notification_hash)

                        expect(session).to have_received(:close_folder).with(folder_id: "folder_uuid")
                        expect(shipment.reload).to have_attributes(hubee_status: "done", hubee_folder_id: nil)
                      end
                    end
                  end

                  context "when the event is not a final status" do
                    it "does not remove hubee ids" do
                      expect {
                        interactor
                        shipment.reload
                      }.to not_change { shipment.hubee_folder_id }
                        .and not_change { shipment.hubee_case_id }
                    end
                  end
                end

                context "when the shipment is already closed" do
                  let!(:shipment) { create(:shipment, hubee_case_id: case_id, hubee_folder_id: nil, hubee_status: closed_status) }

                  let(:closed_status) { :done }

                  before do
                    allow(session).to receive(:close_case)
                    allow(session).to receive(:create_event)
                    allow(session).to receive(:close_folder)
                  end

                  shared_examples "a notification for a closed shipment" do
                    it "does not close the case again" do
                      expect(session).not_to receive(:close_case)
                      expect(session).not_to receive(:create_event)
                      expect(session).not_to receive(:close_folder)
                      interactor
                    end

                    it "keeps the shipment status" do
                      expect { interactor }.not_to change { shipment.reload.hubee_status }
                    end

                    it "marks the event received and deletes the notification" do
                      expect(session).to receive(:update_event)
                      expect(session).to receive(:delete_notification)
                      interactor
                    end
                  end

                  context "when the same final status comes again" do
                    let(:status) { "DONE" }

                    it_behaves_like "a notification for a closed shipment"
                  end

                  context "when another final status comes" do
                    let(:status) { "REFUSED" }

                    it_behaves_like "a notification for a closed shipment"
                  end

                  context "when a non-final status comes" do
                    let(:status) { "IN_PROGRESS" }

                    it_behaves_like "a notification for a closed shipment"
                  end

                  context "when the shipment was refused" do
                    let(:closed_status) { :refused }
                    let(:status) { "DONE" }

                    it_behaves_like "a notification for a closed shipment"
                  end
                end

                context "when the shipment was left half closed, final with its folder id kept" do
                  let!(:shipment) { create(:shipment, hubee_case_id: case_id, hubee_folder_id: "folder_uuid", hubee_status: :done) }

                  let(:status) { "DONE" }

                  before do
                    allow(session).to receive(:close_case)
                    allow(session).to receive(:create_event)
                    allow(session).to receive(:close_folder)
                  end

                  it "closes the case and the folder, then erases the folder id" do
                    interactor

                    expect(session).to have_received(:close_case).with(case_id: "1234")
                    expect(session).to have_received(:close_folder).with(folder_id: "folder_uuid")
                    expect(shipment.reload).to have_attributes(hubee_status: "done", hubee_folder_id: nil)
                  end
                end

                context "when there is no matching shipment" do
                  let(:case_id) { "5678" }
                  let(:status) { "DONE" }

                  before do
                    allow(session).to receive(:close_case)
                    allow(session).to receive(:create_event)
                  end

                  it "does not close the folder" do
                    expect(session).not_to receive(:close_folder)
                    interactor
                  end

                  it "alerts once per case" do
                    expect(Sentry).to receive(:capture_message).with(
                      "No shipment found for case_id: 1234, cannot delete folder.",
                      fingerprint: ["hubee-notification-without-shipment", "1234"]
                    )
                    interactor
                  end
                end
              end

              context "when the event is not processable" do
                let(:status) { "HUBEE_NOTIFIED" }

                it "does not update the shipment" do
                  expect { interactor }.not_to change { shipment.reload.hubee_status }
                end
              end
            end

            context "when the event is not a status update" do
              let(:action_type) { "ATTACH_DEPOSIT" }

              it_behaves_like "an ignored notification"
            end
          end

          context "when the event is not sent" do
            let(:event_status) { "RECEIVED" }

            it_behaves_like "an ignored notification"
          end
        end

        context "when the event is not fetch correctly" do
          let(:event_payload) { {"errors" => ["some error"]} }

          it_behaves_like "an ignored notification"
        end
      end

      context "when the notification is for a new folder" do
        let(:event_id) { nil }

        it_behaves_like "an ignored notification"
      end
    end

    context "when the notification is not for FormulaireQF" do
      let(:process_code) { "CertDC" }

      it "leaves the notification in the queue for its owner" do
        expect(session).not_to receive(:delete_notification)
        interactor
      end

      it "does not update the event" do
        expect(session).not_to receive(:update_event)
        interactor
      end
    end
  end
end

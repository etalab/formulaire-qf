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

                    it "removes hubee ids" do
                      expect {
                        interactor
                        shipment.reload
                      }.to change { shipment.hubee_folder_id }.to(nil)
                        .and change { shipment.hubee_case_id }.to(nil)
                    end

                    it "closes the folder" do
                      expect(session).to receive(:close_case)
                      expect(session).to receive(:create_event)
                      expect(session).to receive(:close_folder)
                      interactor
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

                  it "logs an error" do
                    expect(Sentry).to receive(:capture_message).with("No shipment found for case_id: 1234, cannot delete folder.")
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

      it_behaves_like "an ignored notification"
    end
  end
end

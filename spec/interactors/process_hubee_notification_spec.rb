require "rails_helper"

RSpec.describe ProcessHubEENotification, type: :interactor do
  subject(:interactor) { described_class.call(notification: notification_hash) }

  let(:notification_hash) do
    {
      "caseId" => "1234",
      "eventId" => "5678",
      "processCode" => "FormulaireQF",
      "id" => "abcd",
    }
  end

  describe ".call" do
    let(:event_payload) do
      {
        "actionType" => "STATUS_UPDATE",
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
        "status" => "SENT",
        "transmitter" => {
          "type" => "SI",
          "branchCode" => "04107",
          "companyRegister" => "21040107100019",
        },
        "updateDateTime" => nil,
      }
    end
    let(:session) { instance_double(HubEE::Api) }
    let(:status) { "SI_RECEIVED" }

    before do
      allow(HubEE::Api).to receive(:session).and_return(session)
      allow(session).to receive(:event).and_return(event_payload)
      allow(session).to receive(:update_event)
      allow(session).to receive(:delete_notification)
    end

    it "deletes the notification" do
      expect(session).to receive(:delete_notification)
      interactor
    end

    context "when the notification is for FormulaireQF" do
      context "when the notification is for a new folder" do
        context "when the event is valid, sent, and a status update" do
          let!(:shipment) { create(:shipment, hubee_case_id: "1234") }

          it "update the hubee event" do
            expect(session).to receive(:update_event)
            interactor
          end

          context "when the event is processable" do
            it "updates the shipment status" do
              expect { interactor }.to change { shipment.reload.hubee_status }.to("si_received")
            end

            context "when the event is a final status" do
              let(:status) { "DONE" }

              it "removes hubee ids" do
                expect {
                  interactor
                  shipment.reload
                }.to change { shipment.hubee_folder_id }.to(nil)
                  .and change { shipment.hubee_case_id }.to(nil)
              end
            end
          end
        end
      end
    end
  end
end

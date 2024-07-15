require "rails_helper"

RSpec.describe HubEE::Event, type: :model do
  subject(:event) { described_class.new(event_hash) }

  let(:event_hash) do
    {
      "actionType" => "STATUS_UPDATE",
      "attachments" => [],
      "author" => "John Doe",
      "caseCurrentStatus" => "SENT",
      "caseNewStatus" => "SI_RECEIVED",
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

  describe "#case_current_status" do
    it "returns the case current status" do
      expect(event.case_current_status).to eq("SENT")
    end
  end

  describe "#case_new_status" do
    it "returns the case new status" do
      expect(event.case_new_status).to eq("SI_RECEIVED")
    end
  end

  describe "#error?" do
    context "when the event status is error" do
      let(:event_hash) do
        {"errors" => "ERROR"}
      end

      it "returns true" do
        expect(event.error?).to be true
      end
    end

    context "when the event status is not error" do
      let(:event_hash) do
        {}
      end

      it "returns false" do
        expect(event.error?).to be false
      end
    end
  end

  describe "#final_status?" do
    context "when the case new status is final" do
      let(:event_hash) do
        {"caseNewStatus" => "DONE"}
      end

      it "returns true" do
        expect(event.final_status?).to be true
      end
    end

    context "when the case new status is not final" do
      let(:event_hash) do
        {"caseNewStatus" => "SENT"}
      end

      it "returns false" do
        expect(event.final_status?).to be false
      end
    end
  end

  describe "#processable?" do
    context "when the event is processable" do
      let(:event_hash) do
        {"caseNewStatus" => "SENT"}
      end

      it "returns true" do
        expect(event.processable?).to be true
      end
    end

    context "when the event is not processable" do
      let(:event_hash) do
        {"caseNewStatus" => "RECEIVED"}
      end

      it "returns false" do
        expect(event.processable?).to be false
      end
    end
  end

  describe "#sent?" do
    context "when the event status is sent" do
      let(:event_hash) do
        {"status" => "SENT"}
      end

      it "returns true" do
        expect(event.sent?).to be true
      end
    end

    context "when the event status is not sent" do
      let(:event_hash) do
        {"status" => "RECEIVED"}
      end

      it "returns false" do
        expect(event.sent?).to be false
      end
    end
  end

  describe "#status" do
    it "returns the status" do
      expect(event.status).to eq("SENT")
    end
  end

  describe "#status_update?" do
    context "when the action type is status update" do
      let(:event_hash) do
        {"actionType" => "STATUS_UPDATE"}
      end

      it "returns true" do
        expect(event.status_update?).to be true
      end
    end

    context "when the action type is not status update" do
      let(:event_hash) do
        {"actionType" => "ATTACH_DEPOSIT"}
      end

      it "returns false" do
        expect(event.status_update?).to be false
      end
    end
  end
end

require "rails_helper"

RSpec.describe HubEE::Notification, type: :model do
  subject(:notification) { described_class.new(notification_hash) }

  let(:notification_hash) do
    {
      "caseId" => "1234",
      "eventId" => "5678",
      "processCode" => "FormulaireQF",
      "id" => "abcd",
    }
  end

  describe "#case_id" do
    it "returns the case id" do
      expect(notification.case_id).to eq("1234")
    end
  end

  describe "#event_id" do
    it "returns the event id" do
      expect(notification.event_id).to eq("5678")
    end
  end

  describe "#formulaire_qf?" do
    context "when the process code is FormulaireQF" do
      it "returns true" do
        expect(notification.formulaire_qf?).to be true
      end
    end

    context "when the process code is not FormulaireQF" do
      let(:notification_hash) do
        {"processCode" => "Other"}
      end

      it "returns false" do
        expect(notification.formulaire_qf?).to be false
      end
    end
  end

  describe "#id" do
    it "returns the id" do
      expect(notification.id).to eq("abcd")
    end
  end

  describe "#new_folder?" do
    context "when the event id is blank" do
      let(:notification_hash) do
        {"eventId" => ""}
      end

      it "returns true" do
        expect(notification.new_folder?).to be true
      end
    end

    context "when the event id is not blank" do
      it "returns false" do
        expect(notification.new_folder?).to be false
      end
    end
  end
end

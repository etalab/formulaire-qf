require "rails_helper"

RSpec.describe PrepareQuotientFamilialHubEEFolder, type: :interactor do
  describe ".call" do
    subject(:interactor) { described_class.call(**params) }

    let(:expected_attributes) do
      {
        applicant: identity,
        attachments: [an_object_having_attributes(file_name: "FormulaireQF.json")],
        # TODO: Add back when we upload a proper PDF
        # attachments: [an_object_having_attributes(file_name: "FormulaireQF.json"), an_object_having_attributes(file_name: "FormulaireQF.pdf")],
        cases: [
          external_id: "Formulaire-QF-ABCDEF1234567-01",
          recipient:,
        ],
        external_id: "Formulaire-QF-ABCDEF1234567",
        process_code: "FormulaireQF",
      }
    end
    let(:identity) { double(PivotIdentity) }
    let(:params) do
      {
        identity:,
        recipient:,
      }
    end
    let(:recipient) { double(HubEE::Recipient) }

    before do
      allow(SecureRandom).to receive(:hex).and_return("abcdef1234567thiswontbeused")
    end

    it "exposes the folder" do
      expect(interactor.folder).to have_attributes(expected_attributes)
    end

    it "returns a success result" do
      expect(interactor).to be_success
    end
  end
end

RSpec.describe PrepareQuotientFamilialHubEEFolder, type: :interactor do
  describe ".call" do
    subject(:interactor) { described_class.call(**params) }

    let(:expected_attributes) do
      {
        applicant: pivot_identity,
        attachments: [an_object_having_attributes(file_name: "FormulaireQF.json"), an_object_having_attributes(file_name: "FormulaireQF.xml"), an_object_having_attributes(file_name: "quotient_familial_Heinemeier_Hansson_David.pdf")],
        cases: [
          external_id: "Formulaire-QF-ABCDEF1234567-01",
          recipient:,
        ],
        external_id: "Formulaire-QF-ABCDEF1234567",
        process_code: "FormulaireQF",
      }
    end
    let(:recipient) { double(HubEE::Recipient) }
    let(:pivot_identity) { PivotIdentity.new(first_names: ["David"], last_name: "Heinemeier Hansson", birth_country: "99135", birthplace: nil, birthdate: Date.new(1979, 10, 15), gender: :male) }
    let(:quotient_familial) { FactoryBot.attributes_for(:quotient_familial_payload) }
    let(:collectivity) { create(:collectivity) }
    let(:params) do
      {
        pivot_identity:,
        quotient_familial:,
        collectivity:,
      }
    end

    before do
      allow(HubEE::Recipient).to receive(:new).and_return(recipient)
      allow(SecureRandom).to receive(:hex).and_return("abcdef1234567thiswontbeused")
    end

    it "exposes the folder" do
      expect(interactor.folder).to have_attributes(expected_attributes)
    end

    it "exposes the recipient" do
      expect(interactor.recipient).to eq(recipient)
    end

    it "exposes the initialized shipment" do
      expect(interactor.shipment.persisted?).to be false
      expect(interactor.shipment.reference).to eq "ABCDEF1234567"
      expect(interactor.shipment.collectivity).to eq collectivity
    end

    it "returns a success result" do
      expect(interactor).to be_success
    end
  end
end

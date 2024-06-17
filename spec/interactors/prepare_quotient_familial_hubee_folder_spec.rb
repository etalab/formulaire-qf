require "rails_helper"

RSpec.describe PrepareQuotientFamilialHubEEFolder, type: :interactor do
  describe ".call" do
    subject(:interactor) { described_class.call(**params) }

    let(:expected_attributes) do
      {
        applicant: identity,
        attachments: [an_object_having_attributes(file_name: "FormulaireQF.json"), an_object_having_attributes(file_name: "FormulaireQF.xml"), an_object_having_attributes(file_name: "FormulaireQF.pdf")],
        cases: [
          external_id: "Formulaire-QF-ABCDEF1234567-01",
          recipient:,
        ],
        external_id: "Formulaire-QF-ABCDEF1234567",
        process_code: "FormulaireQF",
      }
    end
    let(:identity) { PivotIdentity.new(first_names: ["David"], last_name: "Heinemeier Hansson", birth_country: "99135", birthplace: nil, birthdate: Date.new(1979, 10, 15), gender: :male) }
    let(:params) do
      {
        identity:,
        quotient_familial:,
        recipient:,
      }
    end
    let(:quotient_familial) do
      {
        "regime" => "CNAF",
        "allocataires" => [
          {
            "nomNaissance" => "DUBOIS",
            "nomUsage" => "DUBOIS",
            "prenoms" => "ANGELA",
            "anneeDateDeNaissance" => "1962",
            "moisDateDeNaissance" => "08",
            "jourDateDeNaissance" => "24",
            "sexe" => "F",
          },
        ],
        "enfants" => [
          {
            "nomNaissance" => "Dujardin",
            "nomUsuel" => "Dujardin",
            "prenoms" => "Jean",
            "sexe" => "M",
            "anneeDateDeNaissance" => "2016",
            "moisDateDeNaissance" => "12",
            "jourDateDeNaissance" => "13",
          },
        ],
        "adresse" => {
          "identite" => "Madame DUBOIS ANGELA",
          "complementInformation" => nil,
          "complementInformationGeographique" => nil,
          "numeroLibelleVoie" => "1 RUE MONTORGUEIL",
          "lieuDit" => nil,
          "codePostalVille" => "75002 PARIS",
          "pays" => "FRANCE",
        },
        "quotientFamilial" => 2550,
        "annee" => 2024,
        "mois" => 2,
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

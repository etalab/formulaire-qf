require "rails_helper"

RSpec.describe UploadQuotientFamilialToHubEE, type: :organizer do
  let(:interactors) do
    [
      PrepareQuotientFamilialHubEEFolder,
      HubEE::PrepareAttachments,
      HubEE::CreateFolder,
      HubEE::UploadAttachments,
      HubEE::MarkFolderComplete,
      HubEE::CleanAttachments,
    ]
  end

  it "creates the folder, uploads the attachments and marks the folder complete" do
    expect(described_class).to organize interactors
  end

  describe ".call" do
    subject { described_class.call(**params) }

    let(:identity) { PivotIdentity.new(first_names: ["David"], last_name: "Heinemeier Hansson", birth_country: "99135", birthplace: nil, birthdate: Date.new(1979, 10, 15), gender: :male) }
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

    let(:recipient) { build(:hubee_recipient) }
    let(:params) do
      {
        quotient_familial:,
        identity:,
        recipient:,
      }
    end

    before do
      allow(SecureRandom).to receive(:hex).and_return("abcdef1234567thiswontbeused")

      stub_hubee
    end

    it { is_expected.to be_a_success }
  end
end

require "rails_helper"

RSpec.describe ApiParticulier::QuotientFamilialV2 do
  let(:params) { {access_token: "token", siret: "a_valid_siret"} }

  describe ".get" do
    subject(:quotient_familial) { described_class.get(**params) }
    let(:instance) { instance_double(described_class) }

    before do
      allow(described_class).to receive(:new).and_return(instance)
      allow(instance).to receive(:get).and_return({})
    end

    it "calls the initializer and get methods" do
      expect(described_class).to receive(:new)
      expect(instance).to receive(:get)
      quotient_familial
    end
  end

  describe "#get" do
    subject(:quotient_familial) { described_class.get(**params) }

    let(:expected_response) do
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
        "enfants" => [],
        "quotientFamilial" => 2550,
        "annee" => 2024,
      }
    end

    before do
      stub_qf_v2
    end

    it "calls the API" do
      expect(quotient_familial).to match(hash_including(expected_response))
    end
  end
end

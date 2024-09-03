RSpec.describe ApiParticulier::QuotientFamilial::V1 do
  let(:params) { {allocataire_number: "2345678", postal_code: "75001", siret: "a_valid_siret"} }

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
        "quotientFamilial" => 1234,
        "mois" => 7,
        "annee" => 2022,
        "allocataires" => [
          {"nomNaissance" => "MARIE DUPONT", "jourDateDeNaissance" => "01", "moisDateDeNaissance" => "03", "anneeDateDeNaissance" => "1988", "sexe" => "F", "nomUsuel" => nil, "prenoms" => nil},
          {"nomNaissance" => "JEAN DUPONT", "jourDateDeNaissance" => "01", "moisDateDeNaissance" => "04", "anneeDateDeNaissance" => "1990", "sexe" => "M", "nomUsuel" => nil, "prenoms" => nil},
        ],
        "enfants" => [
          {"nomNaissance" => "JACQUES DUPONT", "jourDateDeNaissance" => "01", "moisDateDeNaissance" => "01", "anneeDateDeNaissance" => "2010", "sexe" => "M", "nomUsuel" => nil, "prenoms" => nil},
          {"nomNaissance" => "JEANNE DUPONT", "jourDateDeNaissance" => "01", "moisDateDeNaissance" => "02", "anneeDateDeNaissance" => "2012", "sexe" => "F", "nomUsuel" => nil, "prenoms" => nil},
        ],
      }
    end

    before do
      stub_quotient_familial_v1
    end

    it "calls the API and converts the data to the V2 format" do
      expect(quotient_familial).to match(hash_including(expected_response))
    end

    context "when there is an error" do
      before do
        stub_quotient_familial_v1_with_error(:not_found, status: 404)
      end

      it "returns an error" do
        expect(quotient_familial["error"]).to match("not_found")
      end

      it "sends a message to sentry" do
        expect(Sentry).to receive :capture_message
        quotient_familial
      end
    end
  end
end

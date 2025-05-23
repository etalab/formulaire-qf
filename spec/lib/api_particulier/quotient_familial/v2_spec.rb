RSpec.describe ApiParticulier::QuotientFamilial::V2 do
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
        "allocataires" => [
          {
            "nom_naissance" => "DUBOIS",
            "nom_usage" => "DUBOIS",
            "prenoms" => "ANGELA",
            "date_naissance" => "1962-08-24",
            "sexe" => "F",
          },
        ],
        "enfants" => [],
        "quotient_familial" => {
          "fournisseur" => "CNAF",
          "valeur" => 2550,
          "annee" => 2024,
          "mois" => 2,
          "annee_calcul" => 2024,
          "mois_calcul" => 12,
        },
      }
    end

    before do
      stub_quotient_familial_v2(:cnaf_without_children)
    end

    it "calls the API" do
      expect(quotient_familial).to match(hash_including(expected_response))
    end

    context "when there is an error" do
      before do
        stub_quotient_familial_v2_with_error(:not_found, status: 404)
      end

      it "returns an error" do
        expect(quotient_familial["code"]).to match("35003")
      end

      it "sends a message to sentry" do
        expect(Sentry).to receive :capture_message
        quotient_familial
      end
    end
  end
end

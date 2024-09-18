RSpec.describe ShipmentData, type: :model do
  subject(:shipment_data) { described_class.new(external_id:, pivot_identity:, original_pivot_identity:, quotient_familial:) }

  let(:external_id) { "external_id" }
  let(:pivot_identity) { PivotIdentity.new(first_names: ["David"], last_name: "Heinemeier Hansson", birth_country: "99135", birthplace: nil, birthdate: Date.new(1979, 10, 15), gender: :male) }
  let(:original_pivot_identity) { build(:original_pivot_identity) }
  let(:quotient_familial) { FactoryBot.build(:quotient_familial_v2_payload) }
  let(:expected_hash) do
    {
      external_id: "external_id",
      pivot_identity: {
        codePaysLieuDeNaissance: "99135",
        anneeDateDeNaissance: 1979,
        moisDateDeNaissance: 10,
        jourDateDeNaissance: 15,
        codeInseeLieuDeNaissance: nil,
        prenoms: ["David"],
        sexe: "M",
        nomUsuel: "Heinemeier Hansson",
        **original_pivot_identity,
      },
      quotient_familial: {
        regime: "CNAF",
        allocataires: [
          {
            nomNaissance: "DUBOIS",
            nomUsuel: "DUBOIS",
            prenoms: "ANGELA",
            anneeDateDeNaissance: "1962",
            moisDateDeNaissance: "08",
            jourDateDeNaissance: "24",
            sexe: "F",
          },
        ],
        enfants: [
          {
            nomNaissance: "Dujardin",
            nomUsuel: "Dujardin",
            prenoms: "Jean",
            sexe: "M",
            anneeDateDeNaissance: "2016",
            moisDateDeNaissance: "12",
            jourDateDeNaissance: "13",
          },
        ],
        quotientFamilial: 2550,
        annee: 2024,
        mois: 2,
        version: "v2",
      },
    }
  end

  describe "to_h" do
    it "returns the shipment data as a hash" do
      expect(shipment_data.to_h.with_indifferent_access).to match(
        expected_hash.with_indifferent_access
      )
    end
  end

  describe "#to_s" do
    subject(:human_readable_string) { shipment_data.to_s }

    let(:expected_string) do
      "Identifant éditeur (optionnel): external_id\n\nIdentité pivot:\n  - Code Insee pays de naissance: 99135\n  - Code Insee lieu de naissance: \n  - Date de naissance: 15/10/1979\n  - Nom de naissance: Heinemeier Hansson\n  - Prénoms: David\n  - Sexe: M\n\nQuotient familial:\n  - Régime: CNAF\n  - Année: 2024\n  - Mois: 2\n  - Quotient familial: 2550\n  - Allocataires:\n  \n  - Nom de naissance: DUBOIS\n- Nom d'usage: DUBOIS\n- Prénoms: ANGELA\n- Date de naissance: 24/08/1962\n- Sexe: F\n\n\n  \n  - Enfants:\n  \n  - Nom de naissance: Dujardin\n- Nom d'usage: Dujardin\n- Prénoms: Jean\n- Date de naissance: 13/12/2016\n- Sexe: M\n\n\n\n"
    end

    it "returns the shipment data as a string" do
      expect(human_readable_string).to eq(expected_string)
    end

    context "with no data in quotient_familial" do
      let(:quotient_familial) { {} }

      let(:expected_string) do
        "Identifant éditeur (optionnel): external_id\n\nIdentité pivot:\n  - Code Insee pays de naissance: 99135\n  - Code Insee lieu de naissance: \n  - Date de naissance: 15/10/1979\n  - Nom de naissance: Heinemeier Hansson\n  - Prénoms: David\n  - Sexe: M\n\nQuotient familial:\n  ERREUR: La récupération de votre quotient familial n'a pas fonctionné\n\n"
      end

      it "returns the shipment data as a string with the error" do
        expect(human_readable_string).to eq(expected_string)
      end
    end
  end
end

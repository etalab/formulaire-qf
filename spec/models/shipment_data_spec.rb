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
        family_name: "TESTMAN",
        given_name: "Johnny Paul René",
        gender: "male",
        birthdate: "1989-10-08",
        birthplace: "75107",
        birthcountry: "99100",
      },
      quotient_familial_v3: {
        allocataires: [
          {
            date_naissance: "1962-08-24",
            nom_naissance: "DUBOIS",
            nom_usage: "DUBOIS",
            prenoms: "ANGELA",
            sexe: "F",
          },
        ],
        enfants: [
          {
            date_naissance: "2016-12-13",
            nom_naissance: "Dujardin",
            nom_usage: "Dujardin",
            prenoms: "Jean",
            sexe: "M",
          },
        ],
        quotient_familial: {
          annee: 2024,
          annee_calcul: 2024,
          fournisseur: "CNAF",
          mois: 2,
          mois_calcul: 12,
          valeur: 2550,
        },
        version: "v3",
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
      [
        "Identifant éditeur (optionnel): external_id",
        "",
        "Identité pivot:",
        "  Code Insee pays de naissance: 99135",
        "  Code Insee lieu de naissance: ",
        "  Date de naissance: 15/10/1979",
        "  Nom de naissance: Heinemeier Hansson",
        "  Prénoms: David",
        "  Sexe: M",
        "",
        "Quotient familial:",
        "  Régime: CNAF",
        "  Année: 2024",
        "  Mois: 2",
        "  Quotient familial: 2550",
        "",
        "  Allocataires:",
        "",
        "  - Nom de naissance: DUBOIS",
        "    Nom d'usage: DUBOIS",
        "    Prénoms: ANGELA",
        "    Date de naissance: 24/08/1962",
        "    Sexe: F",
        "",
        "  Enfants:",
        "",
        "  - Nom de naissance: Dujardin",
        "    Nom d'usage: Dujardin",
        "    Prénoms: Jean",
        "    Date de naissance: 13/12/2016",
        "    Sexe: M",
        "",
        "",
      ].join("\n")
    end

    it "returns the shipment data as a string" do
      expect(human_readable_string).to eq(expected_string)
    end

    context "with no data in quotient_familial" do
      let(:quotient_familial) { {} }

      let(:expected_string) do
        [
          "Identifant éditeur (optionnel): external_id",
          "",
          "Identité pivot:",
          "  Code Insee pays de naissance: 99135",
          "  Code Insee lieu de naissance: ",
          "  Date de naissance: 15/10/1979",
          "  Nom de naissance: Heinemeier Hansson",
          "  Prénoms: David",
          "  Sexe: M",
          "",
          "Quotient familial:",
          "  ERREUR: La récupération de votre quotient familial via FranceConnect n'a pas fonctionné",
          "",
          "",
        ].join("\n")
      end

      it "returns the shipment data as a string with the error" do
        expect(human_readable_string).to eq(expected_string)
      end
    end
  end
end

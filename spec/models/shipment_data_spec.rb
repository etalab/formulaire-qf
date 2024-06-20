require "rails_helper"

RSpec.describe ShipmentData, type: :model do
  subject(:shipment_data) { described_class.new(external_id:, pivot_identity:, quotient_familial:) }

  let(:external_id) { "external_id" }
  let(:pivot_identity) { PivotIdentity.new(first_names: ["David"], last_name: "Heinemeier Hansson", birth_country: "99135", birthplace: nil, birthdate: Date.new(1979, 10, 15), gender: :male) }
  let(:quotient_familial) { FactoryBot.attributes_for(:quotient_familial_payload) }

  describe "to_h" do
    it "returns the shipment data as a hash" do
      expect(shipment_data.to_h.with_indifferent_access).to match(
        external_id: "external_id",
        pivot_identity: {
          codePaysLieuDeNaissance: "99135",
          anneeDateDeNaissance: 1979,
          moisDateDeNaissance: 10,
          jourDateDeNaissance: 15,
          codeInseeLieuDeNaissance: nil,
          prenoms: ["David"],
          sexe: "M",
          nomUsage: "Heinemeier Hansson",
        },
        quotient_familial: {
          regime: "CNAF",
          allocataires: [
            {
              nomNaissance: "DUBOIS",
              nomUsage: "DUBOIS",
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
        }
      )
    end
  end

  describe "#to_json" do
    subject(:to_json) { shipment_data.to_json }

    let(:expected_json) do
      '{"external_id":"external_id","pivot_identity":{"codePaysLieuDeNaissance":"99135","anneeDateDeNaissance":1979,"moisDateDeNaissance":10,"jourDateDeNaissance":15,"codeInseeLieuDeNaissance":null,"prenoms":["David"],"sexe":"M","nomUsage":"Heinemeier Hansson"},"quotient_familial":{"regime":"CNAF","allocataires":[{"nomNaissance":"DUBOIS","nomUsage":"DUBOIS","prenoms":"ANGELA","anneeDateDeNaissance":"1962","moisDateDeNaissance":"08","jourDateDeNaissance":"24","sexe":"F"}],"enfants":[{"nomNaissance":"Dujardin","nomUsuel":"Dujardin","prenoms":"Jean","sexe":"M","anneeDateDeNaissance":"2016","moisDateDeNaissance":"12","jourDateDeNaissance":"13"}],"quotientFamilial":2550,"annee":2024,"mois":2}}'
    end

    it "returns the shipment data as a json" do
      expect(to_json).to eq(expected_json)
    end
  end

  describe "#to_xml" do
    subject(:to_xml) { shipment_data.to_xml }

    let(:expected_xml) do
      <<~XML
        <?xml version="1.0" encoding="UTF-8"?>
        <hash>
          <external-id>external_id</external-id>
          <pivot-identity>
            <codePaysLieuDeNaissance>99135</codePaysLieuDeNaissance>
            <anneeDateDeNaissance type="integer">1979</anneeDateDeNaissance>
            <moisDateDeNaissance type="integer">10</moisDateDeNaissance>
            <jourDateDeNaissance type="integer">15</jourDateDeNaissance>
            <codeInseeLieuDeNaissance nil="true"/>
            <prenoms type="array">
              <prenom>David</prenom>
            </prenoms>
            <sexe>M</sexe>
            <nomUsage>Heinemeier Hansson</nomUsage>
          </pivot-identity>
          <quotient-familial>
            <regime>CNAF</regime>
            <allocataires type="array">
              <allocataire>
                <nomNaissance>DUBOIS</nomNaissance>
                <nomUsage>DUBOIS</nomUsage>
                <prenoms>ANGELA</prenoms>
                <anneeDateDeNaissance>1962</anneeDateDeNaissance>
                <moisDateDeNaissance>08</moisDateDeNaissance>
                <jourDateDeNaissance>24</jourDateDeNaissance>
                <sexe>F</sexe>
              </allocataire>
            </allocataires>
            <enfants type="array">
              <enfant>
                <nomNaissance>Dujardin</nomNaissance>
                <nomUsuel>Dujardin</nomUsuel>
                <prenoms>Jean</prenoms>
                <sexe>M</sexe>
                <anneeDateDeNaissance>2016</anneeDateDeNaissance>
                <moisDateDeNaissance>12</moisDateDeNaissance>
                <jourDateDeNaissance>13</jourDateDeNaissance>
              </enfant>
            </enfants>
            <quotientFamilial type="integer">2550</quotientFamilial>
            <annee type="integer">2024</annee>
            <mois type="integer">2</mois>
          </quotient-familial>
        </hash>
      XML
    end

    it "returns the shipment data as a xml" do
      expect(to_xml).to eq(expected_xml)
    end
  end

  describe "#to_s" do
    subject(:human_readable_string) { shipment_data.to_s }

    let(:expected_string) do
      "Identifant éditeur (optionnel): external_id\n\nIdentité pivot:\n  - Code Insee pays de naissance: 99135\n  - Code Insee lieu de naissance: \n  - Date de naissance: 15/10/1979\n  - Nom de naissance: Heinemeier Hansson\n  - Prénoms: David\n  - Sexe: M\n\nQuotient familial:\n  - Régime: CNAF\n  - Année: 2024\n  - Mois: 2\n  - Quotient familial: 2550\n  - Allocataires:\n  \n  - Nom de naissance: DUBOIS\n- Nom d'usage: DUBOIS\n- Prénoms: ANGELA\n- Date de naissance: 24/08/1962\n- Sexe: F\n\n\n  \n  - Enfants:\n  \n  - Nom de naissance: Dujardin\n- Nom d'usage: Dujardin\n- Prénoms: Jean\n- Date de naissance: 13/12/2016\n- Sexe: M\n\n\n"
    end

    it "returns the shipment data as a string" do
      expect(human_readable_string).to eq(expected_string)
    end
  end
end

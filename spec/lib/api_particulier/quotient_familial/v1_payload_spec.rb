# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApiParticulier::QuotientFamilial::V1Payload do
  let(:subject) { described_class.new(payload).convert_to_v2_format }

  describe "#convert_to_v2_format" do
    context "when payload contains an error" do
      let(:payload) do
        {
          "error" => "not_found",
          "reason" => "title",
          "message" => "detail",
        }
      end

      let(:expected_response) do
        {
          "code" => nil,
          "title" => "title",
          "detail" => "detail",
        }
      end

      it "returns the expected hash" do
        expect(subject).to eq(expected_response)
      end
    end

    context "when payload does not contain an error" do
      let(:payload) do
        {
          "quotientFamilial" => 1234,
          "mois" => 7,
          "annee" => 2022,
          "allocataires" => [
            {"nomPrenom" => "MARIE DUPONT", "dateDeNaissance" => "01031988", "sexe" => "F"},
            {"nomPrenom" => "JEAN DUPONT", "dateDeNaissance" => "01041990", "sexe" => "M"},
          ],
          "enfants" => [
            {"nomPrenom" => "JACQUES DUPONT", "dateDeNaissance" => "01012010", "sexe" => "M"},
            {"nomPrenom" => "JEANNE DUPONT", "dateDeNaissance" => "01022012", "sexe" => "F"},
          ],
        }
      end

      let(:expected_response) do
        {
          "quotient_familial" => {
            "fournisseur" => "CNAF",
            "valeur" => 1234,
            "annee" => 2022,
            "mois" => 7,
            "annee_calcul" => nil,
            "mois_calcul" => nil,
          },
          "allocataires" => [{
            "date_naissance" => "1988-03-01",
            "nom_naissance" => "MARIE DUPONT",
            "nom_usage" => nil,
            "prenoms" => nil,
            "sexe" => "F",
          }, {
            "date_naissance" => "1990-04-01",
            "nom_naissance" => "JEAN DUPONT",
            "nom_usage" => nil,
            "prenoms" => nil,
            "sexe" => "M",
          }],
          "enfants" => [{
            "date_naissance" => "2010-01-01",
            "nom_naissance" => "JACQUES DUPONT",
            "nom_usage" => nil,
            "prenoms" => nil,
            "sexe" => "M",
          }, {
            "date_naissance" => "2012-02-01",
            "nom_naissance" => "JEANNE DUPONT",
            "nom_usage" => nil,
            "prenoms" => nil,
            "sexe" => "F",
          }],
        }
      end

      it "returns the expected hash" do
        expect(subject).to eq(expected_response)
      end
    end
  end
end

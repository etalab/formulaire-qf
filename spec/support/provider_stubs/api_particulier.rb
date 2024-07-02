require_relative "../provider_stubs"

module ProviderStubs::ApiParticulier
  def stub_qf_v2(kind: :cnaf)
    payload = send(:"#{kind}_payload")
    uri_template = Addressable::Template.new "https://staging.particulier.api.gouv.fr/api/v2/composition-familiale-v2?recipient={siret}"
    status = (kind == :not_found) ? 404 : 200
    stub_request(:get, uri_template).to_return(status: status, body: payload.to_json)
  end

  # TODO : utiliser des factories
  def cnaf_payload
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

  def msa_with_children_payload
    {
      regime: "MSA",
      allocataires: [
        {
          nomNaissance: "ROUX",
          nomUsage: nil,
          prenoms: "JEANNE STEPHANIE",
          anneeDateDeNaissance: "1987",
          moisDateDeNaissance: "06",
          jourDateDeNaissance: "27",
          sexe: "F",
        },
        {
          nomNaissance: "ROUX",
          nomUsage: nil,
          prenoms: "LOIC NATHAN",
          anneeDateDeNaissance: "1979",
          moisDateDeNaissance: "05",
          jourDateDeNaissance: "19",
          sexe: "M",
        },
      ],
      enfants: [
        {
          nomNaissance: "ROUX",
          nomUsage: nil,
          prenoms: "ALEXIS VINCENT",
          anneeDateDeNaissance: "2006",
          moisDateDeNaissance: "04",
          jourDateDeNaissance: "20",
          sexe: "M",
        },
        {
          nomNaissance: "ROUX",
          nomUsage: nil,
          prenoms: "FLEUR EDITH",
          anneeDateDeNaissance: "2004",
          moisDateDeNaissance: "04",
          jourDateDeNaissance: "20",
          sexe: "M",
        },
      ],
      adresse: {
        identite: "Madame ROUX JEANNE",
        complementInformation: nil,
        complementInformationGeographique: nil,
        numeroLibelleVoie: "1 RUE MONTORGUEIL",
        lieuDit: nil,
        codePostalVille: "75002 PARIS",
        pays: "FRANCE",
      },
      quotientFamilial: 150,
      annee: 2023,
      mois: 5,
    }
  end

  def not_found_payload
    {"error" => "not_found", "reason" => "Dossier allocataire inexistant. Le document ne peut être édité.", "message" => "Dossier allocataire inexistant. Le document ne peut être édité."}
  end
end

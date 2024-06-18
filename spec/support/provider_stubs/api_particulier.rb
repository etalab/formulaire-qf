require_relative "../provider_stubs"

module ProviderStubs::ApiParticulier
  def stub_qf_v2
    payload = {
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

    uri_template = Addressable::Template.new "https://staging.particulier.api.gouv.fr/api/v2/composition-familiale-v2?recipient={siret}"
    stub_request(:get, uri_template).to_return(status: 200, body: payload.to_json)
  end
end

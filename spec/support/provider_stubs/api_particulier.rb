require_relative "../provider_stubs"

module ProviderStubs::ApiParticulier
  def stub_qf_v2(access_token:, recipient:)
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

    stub_request(:get, "https://staging.particulier.api.gouv.fr/api/v2/composition-familiale-v2?recipient=#{recipient}")
      .with(
        headers: {
          "Accept" => "*/*",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
          "Authorization" => "Bearer #{access_token}",
          "Content-Type" => "application/json",
          "Host" => "staging.particulier.api.gouv.fr",
          "User-Agent" => "Ruby",
        }
      )
      .to_return(status: 200, body: payload.to_json, headers: {})
  end
end

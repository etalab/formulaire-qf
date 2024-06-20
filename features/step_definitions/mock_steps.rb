# rubocop:disable Style/MixinUsage
include ProviderStubs::ApiParticulier
include ProviderStubs::HubEE
# rubocop:enable Style/MixinUsage

def mock_france_connect
  OmniAuth.config.test_mode = true

  OmniAuth.config.mock_auth[:france_connect] = OmniAuth::AuthHash.new({
    provider: :france_connect,
    uid: "some_uid",
    info: FactoryBot.attributes_for(:france_connect_payload),
    credentials: {
      token: "token",
      expires_at: 1.hour.from_now.to_i,
      expires: true,
    },
    extra: {
      raw_info: {
        :sub => "some_sub",
        "birthcountry" => "France",
        "birthplace" => "Paris",
        "birthdate" => "1980-01-01",
        "family_name" => "Heinemeier Hansson",
        "given_name" => "David",
        "gender" => "male",
      },
    },
  })
end

Sachantque("je suis un utilisateur qui peut se france connecter") do
  mock_france_connect
end

Sachantque("j'ai des données de quotient familial sur API particuliers") do
  stub_qf_v2
end

Sachantque("hubee peut recevoir un dossier") do
  stub_hubee
end

Sachantque("je suis un utilisateur de FranceConnect avec un quotient familial") do
  steps %(
    Sachant que je suis un utilisateur qui peut se france connecter
    Et que j'ai des données de quotient familial sur API particuliers
  )
end

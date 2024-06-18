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
        sub: "some_sub",
      },
    },
  })
end

def mock_api_particulier
  login_uri_template = Addressable::Template.new "https://staging.particulier.api.gouv.fr/api/v2/composition-familiale-v2?recipient={siret}"
  stub_request(:get, login_uri_template).to_return(body: "{}") # TODO: mock the api_particulier's data
end

Sachantque("je suis un utilisateur qui peut se france connecter") do
  mock_france_connect
  mock_api_particulier
end

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
  })
end

Sachantque("je suis un utilisateur qui peut se france connecter") do
  mock_france_connect
end
# rubocop:disable Style/MixinUsage
include ProviderStubs::ApiParticulier
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
        sub: "some_sub",
      },
    },
  })
end

Sachantque("je suis un utilisateur qui peut se france connecter") do
  mock_france_connect
  stub_qf_v2
end

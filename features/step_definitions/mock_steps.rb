# rubocop:disable Style/MixinUsage
include ProviderStubs::ApiParticulier
include ProviderStubs::HubEE
# rubocop:enable Style/MixinUsage

def mock_france_connect
  OmniAuth.config.test_mode = true

  OmniAuth.config.mock_auth[:france_connect] = OmniAuth::AuthHash.new({
    provider: :france_connect,
    uid: "some_uid",
    info: {},
    credentials: {
      token: "token",
      expires_at: 1.hour.from_now.to_i,
      expires: true,
    },
    extra: {
      raw_info: FactoryBot.attributes_for(:france_connect_payload),
    },
  })
end

Sachantque("j'ai un compte sur FranceConnect") do
  mock_france_connect
end

Sachantque("j'ai un quotient familial CAF sans enfants") do
  stub_qf_v2
end

Sachantque("j'ai un quotient familial msa avec des enfants") do
  stub_qf_v2(kind: :msa_with_children)
end

Sachantque("hubee peut recevoir un dossier") do
  stub_hubee
end

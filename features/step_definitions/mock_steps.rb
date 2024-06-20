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

Sachantque("mon quotient familial est indisponible") do
  stub_qf_v2(kind: :not_found)
end

Sachantque("hubee peut recevoir un dossier") do
  stub_hubee_token
  stub_hubee_create_folder(names: "TESTMAN_Johnny_Paul_René")
  stub_hubee_upload_attachment
  stub_hubee_mark_folder_complete
  stub_hubee_delete_folder
end

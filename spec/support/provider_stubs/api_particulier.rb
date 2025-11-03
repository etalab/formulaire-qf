require_relative "../provider_stubs"

module ProviderStubs::ApiParticulier
  def stub_quotient_familial_v2(factory_trait, status: 200)
    payload = {
      data: FactoryBot.build(:quotient_familial_v2_payload, factory_trait),
      links: {},
      meta: {},
    }.deep_symbolize_keys
    stub_qf_v2(payload, status)
  end

  def stub_quotient_familial_v2_with_error(factory_trait, status: 404)
    payload = {
      errors: [FactoryBot.build(:quotient_familial_v2_error_payload, factory_trait)],
    }
    stub_qf_v2(payload, status)
  end

  protected

  def stub_qf_v2(payload, status)
    stub_url "https://staging.particulier.api.gouv.fr/v3/dss/quotient_familial/france_connect?recipient={siret}", payload, status
  end

  def stub_url(url, payload, status)
    uri_template = Addressable::Template.new url
    stub_request(:get, uri_template).to_return(status: status, body: payload.to_json)
  end
end

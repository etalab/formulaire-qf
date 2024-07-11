require_relative "../provider_stubs"

module ProviderStubs::ApiParticulier
  def stub_quotient_familial(factory_trait, status: 200)
    payload = FactoryBot.build(:quotient_familial_payload, factory_trait)
    stub_qf_v2(payload, status)
  end

  def stub_quotient_familial_with_error(factory_trait, status: 404)
    payload = FactoryBot.build(:quotient_familial_error_payload, factory_trait)
    stub_qf_v2(payload, status)
  end

  protected

  def stub_qf_v2(payload, status)
    uri_template = Addressable::Template.new "https://staging.particulier.api.gouv.fr/api/v2/composition-familiale-v2?recipient={siret}"
    stub_request(:get, uri_template).to_return(status: status, body: payload.to_json)
  end
end

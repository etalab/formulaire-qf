class SetupCollectivityJob < ApplicationJob
  def perform(datapass_id:, collectivity_siret:, collectivity_email:, service_provider:, applicant:)
    organization = Organization.new(collectivity_siret)
    DatapassWebhook::SetupCollectivity.call(datapass_id:, organization:, collectivity_email:, service_provider:, applicant:)
  end
end

class CreateHubEEResourcesJob < ApplicationJob
  def perform(collectivity_siret:, collectivity_email:, service_provider:)
    organization = Organization.new(collectivity_siret)
    DatapassWebhook::CreateHubEEResources.call(organization:, collectivity_email:, service_provider:)
  end
end

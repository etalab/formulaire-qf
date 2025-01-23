class DatapassWebhook::CreateHubEEOrganization < BaseInteractor
  def call
    context.hubee_organization_payload = find_or_create_organization_on_hubee
  end

  private

  def find_or_create_organization_on_hubee
    hubee_api_client.find_or_create_organization(context.organization, context.collectivity_email)
  end

  def hubee_api_client
    @hubee_api_client ||= HubEE::AdminApi.new
  end
end

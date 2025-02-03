class DatapassWebhook::SetupCollectivity < BaseOrganizer
  organize DatapassWebhook::CreateHubEEOrganization,
    DatapassWebhook::CreateHubEESubscription,
    DatapassWebhook::CreateCollectivity

  before do
    context.service_provider ||= {}
  end

  around do |interactor|
    interactor.call
  rescue => e
    if Rails.env.local?
      raise e
    else
      Sentry.set_context(
        "DataPass webhook: create HubEE resources",
        payload: {
          organization: context.organization.siret,
          collectivity_email: context.collectivity_email,
          service_provider: context.service_provider,
        }
      )

      Sentry.capture_exception(e)
    end
  end
end

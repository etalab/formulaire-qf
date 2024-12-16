class DatapassWebhook::CreateHubEEResources < BaseOrganizer
  organize DatapassWebhook::CreateHubEEOrganization,
    DatapassWebhook::CreateHubEESubscription

  around do |interactor|
    interactor.call
  rescue => e
    Sentry.set_context(
      "DataPass webhook: create HuBEE resources",
      payload: {
        todo_params: context.todo_params,
      }
    )

    Sentry.capture_exception(e)
  end
end

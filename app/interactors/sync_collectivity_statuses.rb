class SyncCollectivityStatuses < BaseInteractor
  def call
    response = HubEE::Api.session.active_subscriptions
    subscriptions = response.body

    raise HubEE::Api::Error, "HubEE answered #{response.code} without a list of active subscriptions" unless response.success? && subscriptions.is_a?(Array)
    raise HubEE::Api::Error, "HubEE listed no active subscription" if subscriptions.empty?
    raise HubEE::Api::Error, "HubEE listed #{subscriptions.size} active subscriptions, as many as one answer holds: the list may be cut off" if subscriptions.size >= HubEE::Api::ACTIVE_SUBSCRIPTIONS_LIMIT

    sirets = subscriptions.map { |subscription| subscription.dig("subscriber", "companyRegister") }
    raise HubEE::Api::Error, "HubEE listed an active subscription without a SIRET" if sirets.any?(&:blank?)

    Collectivity.transaction do
      Collectivity.inactive.where(siret: sirets).find_each(&:active!)
      Collectivity.active.where.not(siret: sirets).find_each(&:inactive!)
    end
  end
end

class ReadHubEENotificationsJob < ApplicationJob
  queue_as :default

  retry_on Net::ReadTimeout, wait: :polynomially_longer, attempts: 8

  def perform(items_count: 100)
    notifications = HubEE::Api.session.notifications(items_count:).body
    notifications.each do |notification|
      ProcessHubEENotification.call(notification:)
    end
    ReadHubEENotificationsJob.perform_later if notifications.size == items_count
  end
end

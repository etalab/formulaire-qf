class ReadHubEENotificationsJob < ApplicationJob
  queue_as :default

  def perform(items_count: 100)
    notifications = HubEE::Api.session.notifications(items_count:).body
    notifications.each do |notification|
      ProcessHubEENotification.call(notification:)
    end
    ReadHubEENotificationsJob.perform_later if notifications.size == items_count
  end
end

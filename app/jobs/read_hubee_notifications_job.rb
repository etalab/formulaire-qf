class ReadHubEENotificationsJob < ApplicationJob
  queue_as :default

  def perform(items: 100)
    notifications = HubEE::Api.session.notifications(items:)
    notifications.each do |notification|
      ProcessHubEENotification.call(notification:)
    end
    ReadHubEENotificationsJob.perform_later if notifications.size == items
  end
end

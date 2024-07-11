class ProcessHubEENotification < BaseInteractor
  def call
    return unless notification.formulaire_qf?

    return if notification.new_folder?

    return if event.error?

    return unless event.sent? && event.status_update?

    find_and_update_shipment if event.processable?

    session.update_event(id: notification.event_id, case_id: notification.case_id)
  end

  after do
    session.delete_notification(notification_id: notification.id)
  end

  private

  def event
    @event ||= HubEE::Event.new(session.event(id: notification.event_id, case_id: notification.case_id).body)
  end

  def find_and_update_shipment
    return unless shipment

    shipment.update!(hubee_status: event.case_new_status.downcase)
    shipment.update!(hubee_folder_id: nil, hubee_case_id: nil) if event.final_status?
  end

  def notification
    @notification ||= HubEE::Notification.new(context.notification)
  end

  def session
    @session ||= HubEE::Api.session
  end

  def shipment
    @shipment ||= Shipment.find_by(hubee_case_id: notification.case_id)
  end
end

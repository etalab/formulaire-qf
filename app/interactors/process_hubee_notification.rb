class ProcessHubEENotification < BaseInteractor
  def call
    return unless notification.formulaire_qf?

    return if notification.new_folder?

    return if event.error?

    return unless event.sent? && event.status_update?

    if event.processable?
      update_shipment_status
      if event.final_status?
        close_folder
        anonymize_shipment
      end
    end

    session.update_event(id: notification.event_id, case_id: notification.case_id)
  end

  after do
    session.delete_notification(notification_id: notification.id)
  end

  private

  def anonymize_shipment
    return unless shipment

    shipment.update!(hubee_folder_id: nil, hubee_case_id: nil)
  end

  def close_folder
    session.close_case(case_id: notification.case_id)
    session.create_event(case_id: notification.case_id, current_status: event.case_current_status, new_status: "CLOSED")
    if shipment
      session.close_folder(folder_id: shipment.hubee_folder_id)
    else
      Sentry.capture_message("No shipment found for case_id: #{notification.case_id}, cannot delete folder.")
    end
  end

  def event
    @event ||= HubEE::Event.new(session.event(id: notification.event_id, case_id: notification.case_id).body)
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

  def update_shipment_status
    return unless shipment

    shipment.update!(hubee_status: event.case_new_status.downcase)
  end
end

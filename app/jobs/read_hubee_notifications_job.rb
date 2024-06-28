class ReadHubEENotificationsJob < ApplicationJob
  queue_as :default

  class Notification
    def initialize(notification)
      @notification = notification
    end

    def case_id
      @notification["caseId"]
    end

    def event_id
      @notification["eventId"]
    end

    def formulaire_qf?
      @notification["processCode"] == "FormulaireQF"
    end

    def id
      @notification["id"]
    end

    def new_folder?
      event_id.blank?
    end
  end

  class Event
    def initialize(event)
      @event = event
    end

    def case_current_status
      @event["caseCurrentStatus"]
    end

    def received?
      @event["status"] == "RECEIVED"
    end

    def sent?
      @event["status"] == "SENT"
    end

    def case_new_status
      @event["caseNewStatus"]
    end

    def valid?
      @event["errors"].blank?
    end
  end

  def perform(*args)
    HubEE::Api.session.notifications.each do |notification|
      notification = Notification.new(notification)
      # Our process looks like it should be the opposite of the editors'
      # Q: will we get notifications for other processCodes? In which case... what should we do?
      if !notification.formulaire_qf?
        Rails.logger.debug { "NOPE #{notification.id}" }
        next
      end
      if notification.new_folder?
        # 1. On new folders we should probably mark them as processed and delete the notification
      else
        # 2. On existing folders
        # 3. Get the event
        event = Event.new(HubEE::Api.session.event(id: notification.event_id, case_id: notification.case_id))
        # 4. Deal with SENT and RECEIVED event statuses
        next unless event.valid?

        if event.sent?
          Rails.logger.debug { "\nSENT #{event.case_current_status} -> #{event.case_new_status}\n" }
        elsif event.received?
          # Rails.logger.debug notification
          HubEE::Api.session.delete_notification(notification_id: notification.id)
        end
      end
    end
  end
end

module HubEE
  class Event
    FINAL_STATUSES = %w[DONE REFUSED].freeze
    PROCESSABLE_EVENTS = %w[SENT SI_RECEIVED IN_PROGRESS DONE REFUSED].freeze

    def initialize(event)
      @event = event
    end

    def case_new_status
      @event["caseNewStatus"]
    end

    def error?
      @event["errors"].present?
    end

    def final_status?
      FINAL_STATUSES.include?(case_new_status)
    end

    def processable?
      PROCESSABLE_EVENTS.include?(case_new_status)
    end

    def sent?
      status == "SENT"
    end

    def status
      @event["status"]
    end

    def status_update?
      @event["actionType"] == "STATUS_UPDATE"
    end
  end
end

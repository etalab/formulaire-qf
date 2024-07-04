module HubEE
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
end

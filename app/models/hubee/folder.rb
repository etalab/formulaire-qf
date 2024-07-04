module HubEE
  class Folder < Data.define(:id, :applicant, :attachments, :cases, :external_id, :process_code)
    def initialize(applicant:, attachments:, cases:, external_id:, process_code:, id: nil)
      super
    end

    def [](key)
      public_send(key)
    end

    def first_case_id
      cases.first.id
    end
  end
end

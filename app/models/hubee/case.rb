module HubEE
  class Case < Data.define(:id, :external_id, :recipient)
    def initialize(external_id:, recipient:, id: nil)
      super
    end

    def [](key)
      public_send(key)
    end
  end
end

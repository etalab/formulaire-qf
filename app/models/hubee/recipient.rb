class Hubee
  class Recipient < Data.define(:siren, :branch_code, :type)
    def initialize(siren:, branch_code:, type: "SI")
      super
    end

    def [](key)
      public_send(key)
    end
  end
end

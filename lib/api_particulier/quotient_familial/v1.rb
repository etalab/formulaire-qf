module ApiParticulier
  module QuotientFamilial
    class V1 < Base
      def initialize(allocataire_number:, postal_code:, siret:)
        @allocataire_number = allocataire_number
        @postal_code = postal_code
        @siret = siret
      end

      def version
        "v1"
      end

      def path
        "api/v2/composition-familiale"
      end

      def query_params
        {recipient: @siret, numeroAllocataire: @allocataire_number, codePostal: @postal_code}
      end

      def add_authentication_headers(request)
        request["X-Api-Key"] = api_key
      end

      def api_key
        Rails.application.credentials.api_particulier.api_key
      end
    end
  end
end

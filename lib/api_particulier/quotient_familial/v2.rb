module ApiParticulier
  module QuotientFamilial
    class V2 < Base
      def initialize(access_token:, siret:)
        @access_token = access_token
        @siret = siret
      end

      def version
        "v2"
      end

      def path
        "api/v2/composition-familiale-v2"
      end

      def query_params
        {recipient: @siret}
      end

      def add_authentication_headers(request)
        request["Authorization"] = "Bearer #{@access_token}"
      end
    end
  end
end

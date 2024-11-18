module ApiParticulier
  module QuotientFamilial
    class V2 < Base
      def initialize(access_token:, siret:)
        @access_token = access_token
        fake_user_token_for_staging
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

      def fake_user_token_for_staging
        @access_token = "cnaf_qfv2" unless Rails.env.production?
      end
    end
  end
end

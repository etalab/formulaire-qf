module ApiParticulier
  module QuotientFamilial
    class V2 < Base
      def initialize(access_token:, siret:)
        @access_token = access_token
        @siret = siret
      end

      def version
        "v3"
      end

      def path
        "v3/dss/quotient_familial/france_connect"
      end

      def query_params
        {recipient: @siret}
      end

      def add_authentication_headers(request)
        request["Authorization"] = "Bearer #{@access_token}"
      end

      def track_error(error, x_request_id)
        extra = {
          request_id: x_request_id,
          siret: @siret,
          code: error["code"],
        }
        Sentry.capture_message(error["title"], extra: extra)
      end

      def quotient_familial(payload)
        payload["data"].merge("version" => version)
      end

      def error_payload(payload)
        payload["errors"].first.merge("version" => version)
      end
    end
  end
end

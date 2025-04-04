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

      def track_error(error, x_request_id)
        extra = {
          user_sub: Current.user.try(:sub),
          request_id: x_request_id,
          siret: @siret,
          error: error["error"],
          reason: error["reason"],
        }
        Sentry.capture_message(error["message"], extra: extra)
      end

      def quotient_familial(payload)
        payload.merge(version:)
      end

      def error_payload(payload)
        payload.merge(version:)
      end
    end
  end
end

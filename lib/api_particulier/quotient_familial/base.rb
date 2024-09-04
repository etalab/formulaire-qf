module ApiParticulier
  module QuotientFamilial
    class Base
      def self.get(**)
        new(**).get
      end

      def version
        raise NotImplementedError
      end

      def path
        raise NotImplementedError
      end

      def query_params
        raise NotImplementedError
      end

      def add_authentication_headers(request)
        raise NotImplementedError
      end

      def get
        base_url = URI("#{Settings.api_particulier.base_url}/#{path}")
        base_url.query = URI.encode_www_form(**query_params)

        Rails.logger.debug base_url

        https = Net::HTTP.new(base_url.host, base_url.port)
        https.use_ssl = true

        request = Net::HTTP::Get.new(base_url)
        request["Content-Type"] = "application/json"
        add_authentication_headers(request)

        response = https.request(request)
        quotient_familial = JSON.parse(response.body || "{}")

        track_error(response, quotient_familial) unless response.is_a?(Net::HTTPSuccess)

        Rails.logger.debug self
        Rails.logger.debug response.body
        Rails.logger.debug quotient_familial

        quotient_familial.merge(version:)
      end

      def track_error(response, parsed_body)
        extra = {
          user_sub: Current.user.try(:sub),
          request_id: response["X-Request-Id"],
          siret: @siret,
          error: parsed_body["error"],
          reason: parsed_body["reason"],
        }
        Sentry.capture_message(parsed_body["message"], extra: extra)
      end
    end
  end
end

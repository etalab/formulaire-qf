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
        https.read_timeout = 20

        request = Net::HTTP::Get.new(base_url)
        request["Content-Type"] = "application/json"
        add_authentication_headers(request)

        response = https.request(request)
        payload = JSON.parse(response.body || "{}")

        Rails.logger.debug self
        Rails.logger.debug response.body
        Rails.logger.debug payload

        if response.is_a?(Net::HTTPSuccess)
          return quotient_familial(payload)
        end

        error = error_payload(payload)
        track_error(error, response["X-Request-Id"]) unless response.is_a?(Net::HTTPSuccess)

        error
      end

      def quotient_familial(payload)
        raise NotImplementedError
      end

      def error_payload(payload)
        raise NotImplementedError
      end
    end
  end
end

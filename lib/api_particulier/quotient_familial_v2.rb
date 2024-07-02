module ApiParticulier
  class QuotientFamilialV2
    def self.get(**)
      new(**).get
    end

    def initialize(access_token:, siret:)
      @access_token = access_token
      @siret = siret
    end

    def get
      base_url = URI("#{Settings.api_particulier.base_url}/api/v2/composition-familiale-v2")
      base_url.query = URI.encode_www_form(recipient: @siret)

      Rails.logger.debug base_url

      https = Net::HTTP.new(base_url.host, base_url.port)
      https.use_ssl = true

      request = Net::HTTP::Get.new(base_url)
      request["Content-Type"] = "application/json"
      request["Authorization"] = "Bearer #{@access_token}a"

      response = https.request(request)
      quotient_familial = JSON.parse(response.body || "{}")

      track_error(quotient_familial) unless response.is_a?(Net::HTTPSuccess)

      Rails.logger.debug self
      Rails.logger.debug response.body
      Rails.logger.debug quotient_familial

      quotient_familial
    end

    def track_error(parsed_body)
      # TODO? add request id and sub FC (loic suggestion)
      Sentry.set_extras(
        {
          siret: @siret,
          error: parsed_body["error"],
          reason: parsed_body["reason"],
        }
      )
      Sentry.capture_message(parsed_body["message"])
    end
  end
end

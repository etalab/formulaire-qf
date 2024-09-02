module ApiParticulier
  class QuotientFamilialV1
    def self.get(**)
      new(**).get
    end

    def initialize(allocataire_number:, postal_code:, siret:)
      @allocataire_number = allocataire_number
      @postal_code = postal_code
      @siret = siret
    end

    def get
      base_url = URI("#{Settings.api_particulier.base_url}/api/v2/composition-familiale")
      base_url.query = URI.encode_www_form(recipient: @siret, numeroAllocataire: @allocataire_number, codePostal: @postal_code)

      Rails.logger.debug base_url

      https = Net::HTTP.new(base_url.host, base_url.port)
      https.use_ssl = true

      request = Net::HTTP::Get.new(base_url)
      request["Content-Type"] = "application/json"
      request["X-Api-Key"] = api_key

      response = https.request(request)
      quotient_familial = JSON.parse(response.body || "{}")

      track_error(response, quotient_familial) unless response.is_a?(Net::HTTPSuccess)

      Rails.logger.debug self
      Rails.logger.debug response.body
      Rails.logger.debug quotient_familial

      quotient_familial
    end

    def api_key
      Rails.application.credentials.api_particulier.api_key
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

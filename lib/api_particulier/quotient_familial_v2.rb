module ApiParticulier
  class QuotientFamilialV2
    def self.get(**)
      new(**).get
    end

    def initialize(fc_access_token:, recipient:)
      @access_token = fc_access_token
      @recipient = recipient
    end

    def get
      base_url = URI("#{Settings.api_particulier.base_url}/api/v2/composition-familiale-v2")
      base_url.query = URI.encode_www_form(recipient: @recipient)

      Rails.logger.debug base_url

      https = Net::HTTP.new(base_url.host, base_url.port)
      https.use_ssl = true

      request = Net::HTTP::Get.new(base_url)
      request["Content-Type"] = "application/json"
      request["Authorization"] = "Bearer #{@access_token}"

      response = https.request(request)
      quotient_familial = JSON.parse(response.body || "{}")

      Rails.logger.debug response
      Rails.logger.debug quotient_familial

      quotient_familial
    end
  end
end

module INSEESirenePublic
  class Api
    def etablissement(siret:)
      http_connection.get(
        "https://api.insee.fr/api-sirene/3.11/siret/#{siret}"
      ).body
    end

    private

    def http_connection
      @http_connection ||= Faraday.new do |conn|
        conn.request :retry, max: 5
        conn.response :raise_error
        conn.response :json
        conn.options.timeout = 2
        conn.headers["X-INSEE-Api-Key-Integration"] = api_key
      end
    end

    def api_key
      Rails.application.credentials.insee_sirene_public_api_key
    end
  end
end

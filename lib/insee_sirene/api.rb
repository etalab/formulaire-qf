module INSEESirene
  class Api < Base
    def etablissement(siret:)
      http_connection.get(
        "https://api.insee.fr/entreprises/sirene/V3.11/siret/#{siret}"
      ).body
    end

    protected

    def http_connection
      super do |conn|
        conn.request :authorization, "Bearer", -> { Auth.new.access_token }
      end
    end
  end
end

require "omniauth_openid_connect"

OpenIDConnect.http_config do |config|
  config.response :jwt
end

module OmniAuth
  module Strategies
    class FranceConnect < OpenIDConnect
      option :callback_path, "/callback"
      option :client_auth_method, :jwks
      option :response_type, :code
      option :client_signing_alg, :ES256
      option :state, -> do
        SecureRandom.hex(16)
      end
      option :discovery, true

      option :client_options, {
        port: 443,
        scheme: "https",
        authorization_endpoint: "/api/v2/authorize",
        jwks_uri: "/api/v2/jwks",
        token_endpoint: "/api/v2/token",
        userinfo_endpoint: "/api/v2/userinfo",
      }
    end
  end
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider(
    :france_connect,
    client_options: {
      host: Settings.france_connect.host,
      identifier: Settings.france_connect.identifier,
      redirect_uri: Settings.france_connect.redirect_uri,
      secret: Settings.france_connect.secret,
    },
    issuer: "https://#{Settings.france_connect.host}/api/v2",
    discovery: true,
    jwks_uri: "https://#{Settings.france_connect.host}/api/v2/jwks",
    name: :france_connect,
    scope: %i[openid identite_pivot cnaf_quotient_familial cnaf_allocataires cnaf_enfants],
    acr_values: "eidas1"
  )
end

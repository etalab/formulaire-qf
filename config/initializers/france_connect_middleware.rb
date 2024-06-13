require "omniauth_openid_connect"

module OmniAuth
  module Strategies
    class FranceConnect < OpenIDConnect
      option :callback_path, "/callback"
      option :client_auth_method, :secret
      option :client_signing_alg, :HS256
      option :state, -> { SecureRandom.hex(16) }

      option :client_options, {
        port: 443,
        scheme: "https",
        authorization_endpoint: "/api/v1/authorize?acr_values=eidas1",
        token_endpoint: "/api/v1/token",
        userinfo_endpoint: "/api/v1/userinfo",
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
    issuer: "https://#{Settings.france_connect.host}",
    name: :france_connect,
    scope: %i[openid identite_pivot cnaf_quotient_familial cnaf_allocataires cnaf_enfants]
  )
end

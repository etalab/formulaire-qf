class Api::ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  private
    def authenticate
      authenticate_or_request_with_http_token do |token, options|
        # Compare the tokens in a time-constant manner, to mitigate timing attacks.
        ActiveSupport::SecurityUtils.secure_compare(token, Rails.application.credentials.api_key)
      end
    end
end

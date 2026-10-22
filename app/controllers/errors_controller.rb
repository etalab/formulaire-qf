class ErrorsController < ApplicationController
  def auth_failure
    @message = params[:message]
    @strategy = params[:strategy]

    Sentry.capture_message("Authentication failure #{@message}", extra: {message: @message, strategy: @strategy})
  end
end

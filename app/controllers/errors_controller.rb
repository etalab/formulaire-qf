class ErrorsController < ApplicationController
  def auth_failure
    @message = params[:message]

    Sentry.capture_message("Authentication failure #{@message}", extra: {message: @message})
  end
end

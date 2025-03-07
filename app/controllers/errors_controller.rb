class ErrorsController < ApplicationController
  def auth_failure
    @message = params[:message]
    @strategy = params[:strategy]
  end
end

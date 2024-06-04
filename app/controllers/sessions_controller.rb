class SessionsController < ApplicationController
  def new
    render :new
  end

  def create
    session[:auth] = request.env["omniauth.auth"]

    redirect_to claims_path(recipient: "13002526500013")
  end
end

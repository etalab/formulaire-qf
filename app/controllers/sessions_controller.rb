class SessionsController < ApplicationController
  def new
    render :new
  end

  def create
    session[:auth] = request.env["omniauth.auth"]

    result = GetFamilyQuotient.call(recipient: Current.recipient, user: Current.user)

    if result.success?
      session["quotient_familial"] = result.quotient_familial
      Current.quotient_familial = result.quotient_familial

      redirect_to new_collectivity_shipment_path("13002526500013")
    else
      # render new_collectivity_shipment_path, flash with result.error
      raise
    end
  end
end

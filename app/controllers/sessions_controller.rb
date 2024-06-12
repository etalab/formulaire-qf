class SessionsController < ApplicationController
  before_action :set_collectivity_from_session, only: :create

  def new
    render :new
  end

  def create
    session[:auth] = request.env["omniauth.auth"]

    result = GetFamilyQuotient.call(recipient: Current.recipient, user: Current.user)

    if result.success?
      session["quotient_familial"] = result.quotient_familial
      Current.quotient_familial = result.quotient_familial

      redirect_to new_collectivity_shipment_path(@collectivity.siret)
    else
      # render new_collectivity_shipment_path, flash with result.error
      raise
    end
  end

  def set_collectivity_from_session
    @collectivity = Collectivity.find_by(siret: session["collectivity_id"])
  end
end

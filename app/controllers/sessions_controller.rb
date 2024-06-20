class SessionsController < ApplicationController
  def new
    render :new
  end

  def create
    session[:auth] = request.env["omniauth.auth"]
    session[:auth]["state"] = params[:state]

    SetupCurrentData.call(session:, params:)
    result = GetFamilyQuotient.call(recipient: Current.collectivity.siret, user: Current.user)

    if result.success?
      session["quotient_familial"] = result.quotient_familial
      SetupCurrentData.call(session:, params:)
      Current.quotient_familial = result.quotient_familial

      redirect_to new_collectivity_shipment_path(Current.collectivity.siret)
    else
      # render new_collectivity_shipment_path, flash with result.error
      raise
    end
  end

  def destroy
    id_token_hint = session[:auth]["credentials"]["id_token"]
    state = session[:auth]["state"]
    url = "https://fcp.integ01.dev-franceconnect.fr/api/v1/logout?id_token_hint=#{id_token_hint}&post_logout_redirect_uri=#{fc_logout_callback_url}&state=#{state}"
    reset_session

    redirect_to url, allow_other_host: true
  end

  def fc_callback
    redirect_to root_path
  end
end

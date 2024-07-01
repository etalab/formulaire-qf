class SessionsController < ApplicationController
  def new
    render :new
  end

  def create
    session[:raw_info] = request.env["omniauth.auth"]["extra"]["raw_info"]
    session[:france_connect_token] = request.env["omniauth.auth"]["credentials"]["token"]
    session[:france_connect_token_hint] = request.env["omniauth.auth"]["credentials"]["id_token"]
    session[:state] = params[:state]

    SetupCurrentData.call(session:, params:)
    result = GetFamilyQuotient.call(recipient: Current.collectivity.siret, user: Current.user)

    if result.success?
      session["quotient_familial"] = result.quotient_familial
      SetupCurrentData.call(session:, params:)
      Current.quotient_familial = result.quotient_familial

      redirect_to collectivity_new_shipment_path(Current.collectivity.siret)
    else
      # TODO : factorise management of errors
      # render collectivity_new_shipment_path, flash with result.error
      raise
    end
  end

  def destroy
    id_token_hint = session[:france_connect_token_hint]
    state = session["state"]
    url = "https://#{Settings.france_connect.host}/api/v1/logout?id_token_hint=#{id_token_hint}&post_logout_redirect_uri=#{fc_logout_callback_url}&state=#{state}"
    reset_session

    redirect_to url, allow_other_host: true
  end

  def fc_callback
    redirect_to root_path
  end
end

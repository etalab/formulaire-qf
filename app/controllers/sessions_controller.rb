class SessionsController < ApplicationController
  def create
    session[:raw_info] = request.env["omniauth.auth"]["extra"]["raw_info"]
    session[:france_connect_token] = request.env["omniauth.auth"]["credentials"]["token"]
    session[:france_connect_token_hint] = request.env["omniauth.auth"]["credentials"]["id_token"]
    session[:state] = params[:state]
    SetupCurrentData.call(session:, params:)

    result = GetFamilyQuotient.call(siret: Current.collectivity.siret, user: Current.user)

    if result.success?
      session["quotient_familial"] = result.quotient_familial
      SetupCurrentData.call(session:, params:)
      redirect_to collectivity_new_shipment_path(Current.collectivity.siret)
    else
      flash[:error] = {
        title: t("shipments.qf_v2_error.title"),
        text: t("shipments.qf_v2_error.text", message: result.message),
      }

      redirect_to collectivity_shipment_error_path(Current.collectivity.siret)
    end
  end

  def destroy
    id_token_hint = session[:france_connect_token_hint]
    state = session["state"]
    url = "https://#{Settings.france_connect.host}/api/v2/session/end?id_token_hint=#{id_token_hint}&post_logout_redirect_uri=#{fc_logout_callback_url}&state=#{state}"
    reset_session

    redirect_to url, allow_other_host: true
  end

  def fc_callback
    redirect_to root_path
  end
end

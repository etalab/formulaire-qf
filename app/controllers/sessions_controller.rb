class SessionsController < ApplicationController
  def create
    # Handle FranceConnect V2 error parameters
    if params[:error]
      handle_france_connect_error
      return
    end

    session[:raw_info] = request.env["omniauth.auth"]["extra"]["raw_info"]
    session[:france_connect_token] = request.env["omniauth.auth"]["credentials"]["token"]
    session[:france_connect_token_hint] = request.env["omniauth.auth"]["credentials"]["id_token"]
    session[:state] = params[:state]
    # Handle new iss parameter from FranceConnect V2
    session[:iss] = params[:iss] if params[:iss]
    SetupCurrentData.call(session:, params:)

    result = GetFamilyQuotient.call(siret: Current.collectivity.siret, user: Current.user)

    if result.success?
      session["quotient_familial"] = result.quotient_familial
      SetupCurrentData.call(session:, params:)
      redirect_to collectivity_new_shipment_path(Current.collectivity.siret)

    elsif result.cnaf_failed?
      flash[:info] = {
        title: t("shipments.qf_v2_error.title"),
        text: t("shipments.qf_v2_error.text", message: result.message),
      }

      redirect_to collectivity_cnaf_v1_family_quotients_path(Current.collectivity.siret)
    else
      flash[:error] = {
        title: t("shipments.qf_v1_error.title"),
        text: t("shipments.qf_v1_error.text", message: result.message),
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

  private

  def handle_france_connect_error
    error_code = params[:error]
    error_description = params[:error_description]
    
    case error_code
    when "access_denied"
      flash[:error] = {
        title: t("errors.france_connect.access_denied.title"),
        text: t("errors.france_connect.access_denied.text")
      }
    when "invalid_request"
      flash[:error] = {
        title: t("errors.france_connect.invalid_request.title"),
        text: t("errors.france_connect.invalid_request.text")
      }
    when "server_error"
      flash[:error] = {
        title: t("errors.france_connect.server_error.title"),
        text: t("errors.france_connect.server_error.text")
      }
    else
      flash[:error] = {
        title: t("errors.france_connect.generic.title"),
        text: t("errors.france_connect.generic.text", error: error_code, description: error_description)
      }
    end
    
    redirect_to root_path
  end
end

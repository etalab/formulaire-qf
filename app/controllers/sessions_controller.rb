class SessionsController < ApplicationController
  def create
    session[:raw_info] = request.env["omniauth.auth"]["extra"]["raw_info"]
    session[:france_connect_token] = request.env["omniauth.auth"]["credentials"]["token"]
    session[:france_connect_token_hint] = request.env["omniauth.auth"]["credentials"]["id_token"]
    session[:state] = params[:state]
    session.delete("quotient_familial")
    SetupCurrentData.call(session:, params:)

    result = GetFamilyQuotient.call(siret: Current.collectivity.siret, user: Current.user)

    if result.success?
      session["quotient_familial"] = {Current.collectivity.siret => result.quotient_familial}
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
    end_france_connect_session(return_to: root_path)
  end

  def fc_callback
    redirect_to session.delete("return_to") || root_path
  end
end

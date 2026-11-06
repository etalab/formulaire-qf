class ApplicationController < ActionController::Base
  before_action :set_up_current_data, :set_up_browser_title

  private

  def end_france_connect_session(return_to:, keep: {})
    url = "https://#{Settings.france_connect.host}/api/v2/session/end?id_token_hint=#{session[:france_connect_token_hint]}&post_logout_redirect_uri=#{fc_logout_callback_url}&state=#{session["state"]}"
    reset_session
    session.update(keep.merge("return_to" => return_to))

    redirect_to url, allow_other_host: true
  end

  def session_kept_for_next_person
    siret = Current.collectivity.siret
    redirect_uri = session.dig("portals", siret, "redirect_uri")
    kept = session.to_hash.slice("siret")
    redirect_uri ? kept.merge("portals" => {siret => {"redirect_uri" => redirect_uri}}) : kept
  end

  def set_up_current_data
    SetupCurrentData.call(session: session, params: params)
  end

  def set_up_browser_title
    default_title = t("layout.title")
    @browser_title = t("#{controller_name}.#{action_name}.browser_title", collectivity_name: Current.collectivity.try(:name), default: default_title)

    if @browser_title != default_title
      @browser_title = "#{@browser_title} | #{default_title}"
    end
  end
end

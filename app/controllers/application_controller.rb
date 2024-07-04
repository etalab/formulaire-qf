class ApplicationController < ActionController::Base
  before_action :set_up_current_data, :set_up_browser_title

  private

  def set_up_current_data
    SetupCurrentData.call(session: session, params: params)
  end

  def set_up_browser_title
    default_title = t("layout.title")
    @browser_title = t("#{controller_name}.#{action_name}.browser_title", default: default_title)

    if @browser_title != default_title
      @browser_title = "#{@browser_title} | #{default_title}"
    end
  end
end

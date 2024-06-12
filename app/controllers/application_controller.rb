class ApplicationController < ActionController::Base
  before_action :set_up_current_data

  private

  def set_up_current_data
    SetupCurrentData.call(session: session, params: params)
  end
end

class ApplicationController < ActionController::Base
  before_action :identify_user

  private

  def identify_user
    Current.user = PivotIdentity.new(auth: session_auth, recipient:)
    Current.quotient_familial = quotient_familial
  end

  def quotient_familial
    session.fetch("quotient_familial", {})
  end

  def recipient
    params.fetch(:recipient, "")
  end

  def session_auth
    session.fetch("auth", {})
  end
end

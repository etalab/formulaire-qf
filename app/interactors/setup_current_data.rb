class SetupCurrentData < BaseInteractor
  def call
    Current.pivot_identity = pivot_identity
    Current.quotient_familial = quotient_familial
    Current.recipient = recipient
    Current.user = user
  end

  private

  def pivot_identity
    PivotIdentity.new(**FranceConnect::IdentityMapper.normalize(session_auth))
  end

  def quotient_familial
    context.session.fetch("quotient_familial", {})
  end

  def recipient
    context.params.fetch(:recipient, context.session.fetch("recipient", ""))
  end

  def session_auth
    context.session.fetch("auth", {})
  end

  def user
    User.new(**FranceConnect::AuthMapper.normalize(session_auth))
  end
end

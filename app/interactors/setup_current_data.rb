class SetupCurrentData < BaseInteractor
  def call
    Current.pivot_identity = pivot_identity
    Current.quotient_familial = quotient_familial
    Current.collectivity = collectivity
    Current.user = user
  end

  private

  def pivot_identity
    PivotIdentity.new(**FranceConnect::IdentityMapper.normalize(session_auth))
  end

  def quotient_familial
    context.session.fetch("quotient_familial", {})
  end

  def collectivity
    siret = context.params.fetch(:collectivity_id, context.session.fetch("siret", ""))
    Collectivity.find_by(siret: siret) || Collectivity.new
  end

  def session_auth
    context.session.fetch("auth", {})
  end

  def user
    User.new(**FranceConnect::AuthMapper.normalize(session_auth))
  end
end

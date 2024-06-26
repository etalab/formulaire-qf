class SetupCurrentData < BaseInteractor
  def call
    Current.pivot_identity = pivot_identity
    Current.quotient_familial = quotient_familial
    Current.collectivity = collectivity
    Current.user = user
  end

  private

  def pivot_identity
    PivotIdentity.new(**FranceConnect::IdentityMapper.normalize(session_raw_info))
  end

  def quotient_familial
    context.session.fetch("quotient_familial", {})
  end

  def collectivity
    siret = context.params.fetch(:collectivity_id, context.session.fetch("siret", ""))
    Collectivity.find_by(siret: siret) || Collectivity.new
  end

  def session_raw_info
    context.session.fetch("raw_info", {})
  end

  def user
    User.new(**FranceConnect::AuthMapper.normalize(session_raw_info).merge(access_token: context.session[:france_connect_token]))
  end
end

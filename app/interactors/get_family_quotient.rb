class GetFamilyQuotient < BaseInteractor
  def call
    context.quotient_familial = ApiParticulier::QuotientFamilialV2.get(access_token: context.user.access_token, siret: context.siret)
  end
end

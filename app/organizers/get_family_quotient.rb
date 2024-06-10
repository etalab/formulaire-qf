class GetFamilyQuotient < BaseInteractor
  def call
    context.quotient_familial = ApiParticulier::QuotientFamilialV2.get(fc_access_token: context.identity.token, recipient: context.identity.recipient)
  end
end

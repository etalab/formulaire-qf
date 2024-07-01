class GetFamilyQuotient < BaseInteractor
  def call
    quotient_familial = ApiParticulier::QuotientFamilialV2.get(access_token: context.user.access_token, siret: context.siret)

    if quotient_familial["error"].present?
      context.fail!(message: error_message(quotient_familial))
    else
      context.quotient_familial = quotient_familial
    end
  end

  def error_message(quotient_familial)
    quotient_familial["message"] || quotient_familial["reason"] || quotient_familial["error"]
  end
end

class GetFamilyQuotient < BaseInteractor
  def call
    if quotient_familial["error"].present?
      context.fail!(message: error_message)
    else
      context.quotient_familial = quotient_familial.merge(version: "v2")
    end
  end

  def error_message
    quotient_familial["message"] || quotient_familial["reason"] || quotient_familial["error"]
  end

  private

  def quotient_familial
    @quotient_familial ||= ApiParticulier::QuotientFamilialV2.get(access_token: context.user.access_token, siret: context.siret)
  end
end

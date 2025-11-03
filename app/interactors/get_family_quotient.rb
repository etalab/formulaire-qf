class GetFamilyQuotient < BaseInteractor
  def call
    if error?
      context.fail!(message: error_message)
    else
      context.quotient_familial = quotient_familial
    end
  end

  private

  def error_message
    quotient_familial["detail"]
  end

  def quotient_familial
    @quotient_familial ||= ApiParticulier::QuotientFamilial::V2.get(access_token: context.user.access_token, siret: context.siret)
  end

  def error?
    quotient_familial["detail"].present?
  end
end

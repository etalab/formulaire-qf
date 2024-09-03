class GetCnafV1FamilyQuotient < BaseInteractor
  def call
    if quotient_familial["error"].present?
      context.fail!(message: error_message)
    else
      context.quotient_familial = quotient_familial.merge(version: "v1")
    end
  end

  def error_message
    quotient_familial["message"] || quotient_familial["reason"] || quotient_familial["error"]
  end

  private

  def quotient_familial
    @quotient_familial ||= ApiParticulier::QuotientFamilialV1.get(allocataire_number: context.allocataire_number, postal_code: context.postal_code, siret: context.siret)
  end
end

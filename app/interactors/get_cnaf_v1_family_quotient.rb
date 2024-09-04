class GetCnafV1FamilyQuotient < BaseInteractor
  def call
    if quotient_familial["error"].present?
      context.fail!(message: error_message)
    else
      context.quotient_familial = ApiParticulier::QuotientFamilial::V1Payload.new(quotient_familial).convert_to_v2_format
    end
  end

  private

  def error_message
    quotient_familial["message"] || quotient_familial["reason"] || quotient_familial["error"]
  end

  def quotient_familial
    @quotient_familial ||= ApiParticulier::QuotientFamilial::V1.get(allocataire_number: context.allocataire_number, postal_code: context.postal_code, siret: context.siret)
  end
end

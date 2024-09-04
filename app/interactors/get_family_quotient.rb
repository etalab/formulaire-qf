class GetFamilyQuotient < BaseInteractor
  def call
    if quotient_familial["error"].present?
      context.fail!(message: error_message, cnaf_failed?: cnaf_failed?)
    else
      context.quotient_familial = quotient_familial
    end
  end

  private

  def cnaf_failed?
    error_message.starts_with?("Le dossier allocataire n'a pas été trouvé auprès de la CNAF")
  end

  def error_message
    quotient_familial["message"] || quotient_familial["reason"] || quotient_familial["error"]
  end

  def quotient_familial
    @quotient_familial ||= ApiParticulier::QuotientFamilial::V2.get(access_token: context.user.access_token, siret: context.siret)
  end
end

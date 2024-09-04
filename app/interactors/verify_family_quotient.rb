class VerifyFamilyQuotient < BaseInteractor
  def call
    if verification_failed?
      context.fail!(verification_failed?: true)
    end
  end

  private

  def verification_failed?
    !context.pivot_identity.verify_quotient_familial(context.quotient_familial)
  end
end

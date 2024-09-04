class VerifyFamilyQuotient < BaseInteractor
  def call
    if family_quotient_not_verified?
      context.fail!(reason: :verification_failed)
    end
  end

  private

  def family_quotient_not_verified?
    !context.pivot_identity.verify_quotient_familial(context.quotient_familial)
  end
end

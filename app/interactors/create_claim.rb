class CreateClaim < BaseInteractor
  def call
    claim = Claim.new(claim_params)
    if claim.save
      context.claim = claim
    else
      context.fail!(message: claim.errors.full_messages)
    end
  end

  private

  def claim_params
    {
      sub: context.identity.sub,
      hubee_folder_id: context.folder.id,
    }
  end
end

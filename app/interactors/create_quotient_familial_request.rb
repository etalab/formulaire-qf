class CreateQuotientFamilialRequest < BaseInteractor
  def call
    quotient_familial_request = QuotientFamilialRequest.new(params)
    if quotient_familial_request.save
      context.quotient_familial_request = quotient_familial_request
    else
      context.fail!(message: quotient_familial_request.errors.full_messages)
    end
  end

  private

  def params
    {
      sub: context.identity.sub,
      hubee_folder_id: context.folder.id,
    }
  end
end

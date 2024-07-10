class HubEE::CreateFolder < BaseInteractor
  before do
    context.session ||= HubEE::Api.session
  end

  def call
    response = context.session.create_folder(folder: context.folder)
    context.folder = enhance_folder(response.body)
  end

  def rollback
    context.session.delete_folder(folder_id: context.folder.id)
  end

  private

  def enhance_folder(response)
    attachments = context.folder.attachments.map do |attachment|
      from_response = response["attachments"].find { |hash| hash["fileName"] == attachment.file_name }
      attachment.with(id: from_response["id"])
    end

    cases = context.folder.cases.map do |kase|
      from_response = response["cases"].find { |hash| hash["externalId"] == kase.external_id }
      kase.with(id: from_response["id"])
    end

    context.folder.with(id: response["id"], attachments: attachments, cases: cases)
  end
end

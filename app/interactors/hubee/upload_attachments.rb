class HubEE::UploadAttachments < BaseInteractor
  before do
    context.session ||= HubEE::Api.session
  end

  def call
    context.folder.attachments.each do |attachment|
      response = context.session.upload_attachment(folder_id: context.folder.id, attachment:)
      context.fail!(message: response.body) unless response.success?
    end
  end
end

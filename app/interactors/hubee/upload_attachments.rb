class HubEE::UploadAttachments < BaseInteractor
  before do
    context.session ||= HubEE::Api.session
  end

  def call
    context.folder.attachments.each do |attachment|
      context.session.upload_attachment(folder_id: context.folder.id, attachment:)
    end
  end
end

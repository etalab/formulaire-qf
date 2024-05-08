class Hubee::UploadAttachments < BaseInteractor
  def call
    context.folder.attachments.each do |attachment|
      context.session.upload_attachment(folder_id: context.folder.id, attachment:)
    end
  end
end

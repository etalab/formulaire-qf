class HubEE::PrepareAttachments < BaseInteractor
  def call
    context.folder = context.folder.with(attachments:)
  end

  def rollback
    context.folder.attachments.each do |attachment|
      attachment.close_file
    end
  end

  private

  def attachments
    context.folder.attachments.map do |attachment|
      file = Tempfile.create
      file.write(attachment.file_content)
      file.rewind
      attachment.with(file:, file_size: file.size)
    end
  end
end

class Hubee::CleanAttachments < BaseInteractor
  def call
    context.folder.attachments.each do |attachment|
      attachment.close_file
    end
  end
end

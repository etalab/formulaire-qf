require "rails_helper"

RSpec.describe Hubee::UploadAttachments, type: :interactor do
  subject(:interactor) { described_class.call(**params) }

  let(:attachment) { double(Hubee::Attachment) }
  let(:attachments) { [attachment] }
  let(:folder) { double(Hubee::Folder, id: folder_id, attachments:) }
  let(:folder_id) { "folder_id" }
  let(:params) do
    {
      folder: folder,
      session: session,
    }
  end
  let(:session) { double(Hubee::Api) }

  describe ".call" do
    it "uploads the attachments" do
      expect(session).to receive(:upload_attachment).with(folder_id: folder_id, attachment: attachment)
      interactor
    end
  end
end

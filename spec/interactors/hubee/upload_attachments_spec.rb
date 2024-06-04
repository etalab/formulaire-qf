require "rails_helper"

RSpec.describe HubEE::UploadAttachments, type: :interactor do
  describe ".call" do
    subject(:interactor) { described_class.call(**params) }

    let(:attachment) { double(HubEE::Attachment) }
    let(:attachments) { [attachment] }
    let(:folder) { double(HubEE::Folder, id: folder_id, attachments:) }
    let(:folder_id) { "folder_id" }
    let(:params) do
      {
        folder: folder,
        session: session,
      }
    end
    let(:session) { double(HubEE::Api) }

    it "uploads the attachments" do
      expect(session).to receive(:upload_attachment).with(folder_id: folder_id, attachment: attachment)
      interactor
    end
  end
end

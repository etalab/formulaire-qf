RSpec.describe HubEE::UploadAttachments, type: :interactor do
  describe ".call" do
    subject(:interactor) { described_class.call(**params) }

    let(:attachment) { double(HubEE::Attachment) }
    let(:other_attachment) { double(HubEE::Attachment) }
    let(:attachments) { [attachment, other_attachment] }
    let(:folder) { double(HubEE::Folder, id: folder_id, attachments:) }
    let(:folder_id) { "folder_id" }
    let(:params) do
      {
        folder: folder,
        session: session,
      }
    end
    let(:response) { double(HubEE::Api::Response, success?: true, body: {}) }
    let(:session) { double(HubEE::Api, upload_attachment: response) }

    it "uploads the attachments" do
      interactor
      expect(session).to have_received(:upload_attachment).with(folder_id: folder_id, attachment: attachment)
      expect(session).to have_received(:upload_attachment).with(folder_id: folder_id, attachment: other_attachment)
    end

    context "when hubee returns an error" do
      let(:response) { double(HubEE::Api::Response, success?: false, body: "502 Bad Gateway") }

      it "makes an interactor failure" do
        expect(interactor).to be_a_failure
      end

      it "stops uploading" do
        interactor
        expect(session).to have_received(:upload_attachment).once
      end
    end
  end
end

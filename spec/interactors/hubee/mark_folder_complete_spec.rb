RSpec.describe HubEE::MarkFolderComplete, type: :interactor do
  describe ".call" do
    subject(:interactor) { described_class.call(**params) }

    let(:folder) { double(HubEE::Folder, id: folder_id) }
    let(:folder_id) { "folder_id" }
    let(:params) do
      {
        folder:,
        session:,
      }
    end
    let(:response) { double(HubEE::Api::Response, success?: true, body: {}) }
    let(:session) { double(HubEE::Api, mark_folder_complete: response) }

    it "marks the folder complete" do
      interactor
      expect(session).to have_received(:mark_folder_complete).with(folder_id: folder_id)
    end

    context "when hubee returns an error" do
      let(:response) { double(HubEE::Api::Response, success?: false, body: "503 Service Unavailable") }

      it "makes an interactor failure" do
        expect(interactor).to be_a_failure
      end
    end
  end
end

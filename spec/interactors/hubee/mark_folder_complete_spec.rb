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
    let(:session) { double(HubEE::Api) }

    it "marks the folder complete" do
      expect(session).to receive(:mark_folder_complete).with(folder_id: folder_id)
      interactor
    end
  end
end

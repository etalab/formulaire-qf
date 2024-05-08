require "rails_helper"

RSpec.describe Hubee::MarkFolderComplete, type: :interactor do
  subject(:interactor) { described_class.call(**params) }

  let(:folder) { double(Hubee::Folder, id: folder_id) }
  let(:folder_id) { "folder_id" }
  let(:params) do
    {
      folder:,
      session:,
    }
  end
  let(:session) { double(Hubee::Api) }

  describe ".call" do
    it "marks the folder complete" do
      expect(session).to receive(:mark_folder_complete).with(folder_id: folder_id)
      interactor
    end
  end
end

require "rails_helper"

RSpec.describe HubEE::CreateFolder, type: :interactor do
  subject(:interactor) { described_class.call(**params) }

  let(:params) do
    {
      folder:,
    }
  end

  let(:session) { double(HubEE::Api) }

  before do
    allow(HubEE::Api).to receive(:session).and_return(session)
  end

  describe ".call" do
    let(:folder) { double(HubEE::Folder) }
    it "creates the folder" do
      expect(session).to receive(:create_folder).with(folder:)
      interactor
    end
  end

  describe "#rollback" do
    subject(:rollback) { interactor.rollback }

    let(:folder) { double(HubEE::Folder, id: folder_id) }
    let(:folder_id) { "folder_id" }
    let(:interactor) { described_class.new(**params) }
    let(:params) do
      {
        folder:,
        session:,
      }
    end

    it "deletes the folder" do
      expect(session).to receive(:delete_folder).with(folder_id:)
      rollback
    end
  end
end

require "rails_helper"

RSpec.describe HubEE::CleanAttachments, type: :interactor do
  describe ".call" do
    subject(:interactor) { described_class.call(**params) }

    let(:attachment) { double(HubEE::Attachment) }
    let(:attachments) { [attachment] }
    let(:folder) { double(HubEE::Folder, attachments: attachments) }
    let(:params) do
      {
        folder: folder,
      }
    end

    before do
      allow(attachment).to receive(:close_file)
    end

    it "closes the attachments" do
      expect(attachment).to receive(:close_file)
      interactor
    end
  end
end

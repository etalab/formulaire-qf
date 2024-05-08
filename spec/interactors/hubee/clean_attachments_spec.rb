require "rails_helper"

RSpec.describe Hubee::CleanAttachments, type: :interactor do
  subject(:interactor) { described_class.call(**params) }

  let(:attachment) { double(Hubee::Attachment) }
  let(:attachments) { [attachment] }
  let(:folder) { double(Hubee::Folder, attachments: attachments) }
  let(:params) do
    {
      folder: folder,
    }
  end

  before do
    allow(attachment).to receive(:close_file)
  end

  describe ".call" do
    it "closes the attachments" do
      expect(attachment).to receive(:close_file)
      interactor
    end
  end
end

require "rails_helper"

RSpec.describe Hubee::CreateFolder, type: :organizer do
  let(:interactors) do
    [
      Hubee::PrepareFolder,
      Hubee::PrepareAttachments,
      Hubee::Create,
      Hubee::UploadAttachments,
      Hubee::MarkFolderComplete,
      Hubee::CleanAttachments,
    ]
  end

  it "creates the folder, uploads the attachments and marks the folder complete" do
    expect(described_class).to organize interactors
  end
end

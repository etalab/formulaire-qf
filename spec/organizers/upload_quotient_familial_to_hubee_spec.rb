require "rails_helper"

RSpec.describe UploadQuotientFamilialToHubEE, type: :organizer do
  let(:interactors) do
    [
      PrepareQuotientFamilialHubEEFolder,
      HubEE::PrepareAttachments,
      HubEE::CreateFolder,
      HubEE::UploadAttachments,
      HubEE::MarkFolderComplete,
      HubEE::CleanAttachments,
    ]
  end

  it "creates the folder, uploads the attachments and marks the folder complete" do
    expect(described_class).to organize interactors
  end

  describe ".call" do
    subject { described_class.call(**params) }

    let(:folder) { build(:hubee_folder) }
    let(:identity) { PivotIdentity.new(recipient:, auth: {info: {first_name: "David", last_name: "Heinemeier Hansson"}}) }
    let(:recipient) { build(:hubee_recipient) }
    let(:params) do
      {
        folder:,
        identity:,
        recipient:,
      }
    end

    before do
      allow(SecureRandom).to receive(:hex).and_return("abcdef1234567thiswontbeused")

      stub_hubee_token
      stub_hubee_create_folder
      stub_hubee_upload_attachment
      stub_hubee_mark_folder_complete
    end

    it { is_expected.to be_a_success }
  end
end
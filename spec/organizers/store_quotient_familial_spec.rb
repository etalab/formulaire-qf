require "rails_helper"

RSpec.describe StoreQuotientFamilial, type: :organizer do
  let(:interactors) do
    [
      UploadQuotientFamilialToHubEE,
      CreateClaim,
    ]
  end

  it "setups the folder, sends it to HubEE and cleans afterwards" do
    expect(described_class).to organize interactors
  end

  describe ".call" do
    subject(:organizer) { described_class.call(**params) }

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

    it "creates a claim" do
      expect { organizer }.to change(Claim, :count).by(1)
    end
  end
end

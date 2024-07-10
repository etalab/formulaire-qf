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

    let(:pivot_identity) { PivotIdentity.new(first_names: ["David"], last_name: "Heinemeier Hansson", birth_country: "99135", birthplace: nil, birthdate: Date.new(1979, 10, 15), gender: :male) }
    let(:quotient_familial) { FactoryBot.build(:quotient_familial_payload) }
    let(:collectivity) { create(:collectivity) }
    let(:params) do
      {
        quotient_familial:,
        pivot_identity:,
        collectivity:,
      }
    end

    before do
      allow(SecureRandom).to receive(:hex).and_return("abcdef1234567thiswontbeused")

      stub_hubee
    end

    it { is_expected.to be_a_success }
  end
end

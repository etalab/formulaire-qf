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
    let(:original_pivot_identity) { build(:original_pivot_identity) }
    let(:quotient_familial) { FactoryBot.build(:quotient_familial_v2_payload) }
    let(:collectivity) { create(:collectivity) }
    let(:params) do
      {
        quotient_familial:,
        pivot_identity:,
        original_pivot_identity:,
        collectivity:,
      }
    end

    before do
      allow(SecureRandom).to receive(:hex).and_return("abcdef1234567thiswontbeused")

      stub_hubee
    end

    it { is_expected.to be_a_success }

    context "when HubEE answers an error on an attachment upload" do
      before { stub_hubee_upload_attachment_with_error }

      it { is_expected.to be_a_failure }

      it "deletes the folder on HubEE without marking it complete" do
        subject
        expect(a_request(:delete, %r{/teledossiers/v1/folders/})).to have_been_made.once
        expect(a_request(:patch, %r{/teledossiers/v1/folders/})).not_to have_been_made
      end
    end

    context "when HubEE does not answer" do
      before { allow(Sentry).to receive(:capture_exception) }

      context "when the token endpoint answers a 502" do
        before { stub_hubee_token_with_error }

        it { is_expected.to be_a_failure }

        it "reports the error to Sentry" do
          subject
          expect(Sentry).to have_received(:capture_exception).with(an_instance_of(HubEE::Api::Error))
        end
      end

      context "when the token endpoint times out" do
        before { stub_request(:post, Settings.hubee.token_url).to_timeout }

        it { is_expected.to be_a_failure }
      end

      context "when the token endpoint is unreachable" do
        before { stub_request(:post, Settings.hubee.token_url).to_raise(SocketError) }

        it { is_expected.to be_a_failure }
      end

      context "when HubEE goes down after creating the folder" do
        before do
          stub_request(:put, %r{/teledossiers/v1/folders/.+/attachments/}).to_raise(Errno::ECONNREFUSED)
          stub_request(:delete, %r{/teledossiers/v1/folders/}).to_raise(Errno::ECONNREFUSED)
        end

        it { is_expected.to be_a_failure }
      end
    end
  end
end

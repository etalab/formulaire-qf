RSpec.describe DatapassWebhook::SetupCollectivity, type: :organizer do
  describe ".call" do
    subject(:organizer) { described_class.call(**params) }

    let(:organization) { Organization.new("13002526500013") }
    let(:params) do
      {
        datapass_id: "12345",
        organization:,
        collectivity_email: "collectivity@test.fr",
        service_provider: {},
        applicant:,
      }
    end
    let(:applicant) do
      {
        "email" => "email@test.com",
        "given_name" => "John",
        "family_name" => "Doe",
        "job_title" => "Mayor",
        "phone_number" => "+33123456789",
      }
    end

    before do
      allow(SecureRandom).to receive(:hex).and_return("abcdef1234567thiswontbeused")

      stub_insee
      stub_hubee_admin
    end

    it { is_expected.to be_a_success }

    it "creates a collectivity" do
      expect { organizer }.to change(Collectivity, :count).by(1)
    end
  end
end

RSpec.describe SetupCollectivityJob, type: :job do
  describe "#perform" do
    subject(:perform) do
      described_class.perform_now(
        datapass_id: "12345",
        collectivity_siret: "13002526500013",
        collectivity_email: "collectivity@test.fr",
        service_provider: {},
        applicant:
      )
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
      allow(Sentry).to receive(:capture_message)
      allow(DatapassWebhook::SetupCollectivity).to receive(:call).and_call_original

      stub_insee
      stub_hubee_admin
    end

    context "when the applicant has a phone number" do
      it "sets up the collectivity" do
        expect { perform }.to change(Collectivity, :count).by(1)
        expect(DatapassWebhook::SetupCollectivity).to have_received(:call)
      end

      it "does not alert the team" do
        perform

        expect(Sentry).not_to have_received(:capture_message)
      end
    end

    shared_examples "a request the team is alerted about" do
      before { allow(DatapassWebhook::SetupCollectivity).to receive(:call) }

      it "alerts the team with the SIRET and the DataPass id only" do
        perform

        expect(Sentry).to have_received(:capture_message).with(
          "DataPass webhook: applicant phone number missing, collectivity not set up",
          extra: {siret: "13002526500013", datapass_id: "12345"}
        )
      end

      it "still runs the setup" do
        perform

        expect(DatapassWebhook::SetupCollectivity).to have_received(:call)
      end
    end

    context "when the applicant has no phone number key" do
      before { applicant.delete("phone_number") }

      it_behaves_like "a request the team is alerted about"
    end

    context "when the applicant phone number is nil" do
      before { applicant["phone_number"] = nil }

      it_behaves_like "a request the team is alerted about"
    end

    context "when the applicant phone number is blank" do
      before { applicant["phone_number"] = " " }

      it_behaves_like "a request the team is alerted about"
    end
  end
end

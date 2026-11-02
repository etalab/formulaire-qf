require "sentry/test_helper"

RSpec.describe SetupCollectivityJob, type: :job do
  include Sentry::TestHelper

  describe "#perform" do
    subject(:perform) do
      described_class.perform_now(
        datapass_id: 12345,
        collectivity_siret: "13002526500013",
        collectivity_email: applicant["email"],
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
      stub_insee
      stub_hubee_admin
    end

    context "when the applicant has a phone number" do
      it "sets up the collectivity" do
        expect { perform }.to change(Collectivity, :count).by(1)
      end
    end

    shared_examples "a job failed until the phone number is known" do
      before { setup_sentry_test }

      after { teardown_sentry_test }

      it "fails with the DataPass id and the SIRET" do
        expect { perform }.to raise_error(SetupCollectivityJob::MissingApplicantPhoneNumber, /DataPass 12345, SIRET 13002526500013/)
      end

      it "creates neither the HubEE subscription nor the collectivity" do
        expect { perform }.to raise_error(SetupCollectivityJob::MissingApplicantPhoneNumber)
          .and not_change(Collectivity, :count)
        expect(a_request(:post, %r{referential/v1/subscriptions})).not_to have_been_made
      end

      it "reports one Sentry issue per DataPass request, without the applicant data" do
        expect { perform }.to raise_error(SetupCollectivityJob::MissingApplicantPhoneNumber)

        expect(last_sentry_event.fingerprint).to eq(["SetupCollectivityJob::MissingApplicantPhoneNumber", "12345"])
        expect(last_sentry_event.to_json_compatible.to_s).not_to include(*applicant.values_at("email", "family_name"))
      end
    end

    context "when the applicant has no phone number key" do
      before { applicant.delete("phone_number") }

      it_behaves_like "a job failed until the phone number is known"
    end

    context "when the applicant phone number is nil" do
      before { applicant["phone_number"] = nil }

      it_behaves_like "a job failed until the phone number is known"
    end

    context "when the applicant phone number is blank" do
      before { applicant["phone_number"] = " " }

      it_behaves_like "a job failed until the phone number is known"
    end

    context "when the applicant phone number is only separators" do
      before { applicant["phone_number"] = "-" }

      it_behaves_like "a job failed until the phone number is known"
    end
  end
end

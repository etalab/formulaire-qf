require "rails_helper"

RSpec.describe ReadHubEENotificationsJob, type: :job do
  describe "#perform" do
    subject(:job) { described_class.perform_now(items_count: 1) }

    before do
      stub_hubee_token
      stub_hubee_notifications
    end

    it "processes the notifications" do
      expect(ProcessHubEENotification).to receive(:call)
      job
    end

    context "when there are potential remaining notifications" do
      before do
        allow(ProcessHubEENotification).to receive(:call)
      end

      it "enqueues another job" do
        expect { job }.to have_enqueued_job(described_class)
      end
    end

    context "when HubEE times out" do
      before do
        stub_request(:get, %r{/teledossiers/v1/notifications}).to_timeout
      end

      it "retries the job" do
        expect { job }.to have_enqueued_job(described_class)
      end
    end
  end
end

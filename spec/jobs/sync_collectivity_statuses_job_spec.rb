RSpec.describe SyncCollectivityStatusesJob, type: :job do
  describe "#perform" do
    subject(:perform) { described_class.perform_now }

    it "runs the sync of the collectivities' statuses" do
      allow(SyncCollectivityStatuses).to receive(:call)

      perform

      expect(SyncCollectivityStatuses).to have_received(:call)
    end

    context "when HubEE answers with an error page" do
      before do
        stub_hubee_token
        stub_hubee_active_subscriptions(status: 502, body: "<html><body>502 Bad Gateway</body></html>")
      end

      it "fails, so GoodJob shows it failed" do
        expect { perform }.to raise_error(HubEE::Api::Error, /answered 502 without a list/)
      end
    end
  end
end

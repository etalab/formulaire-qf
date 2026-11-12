RSpec.describe SyncCollectivityStatuses, type: :interactor do
  describe ".call" do
    subject(:call) { described_class.call }

    let!(:belley) { create(:collectivity, name: "Belley", siret: "21010034300016", status: :inactive) }
    let!(:dinum) { create(:collectivity, name: "DINUM", siret: "13002526500013", status: :active) }

    before { stub_hubee_token }

    context "when HubEE lists Belley among its active subscriptions, and not the DINUM" do
      before { stub_hubee_active_subscriptions }

      it "puts Belley in service" do
        expect { call }.to change { belley.reload.status }.from("inactive").to("active")
      end

      it "puts the DINUM out of service" do
        expect { call }.to change { dinum.reload.status }.from("active").to("inactive")
      end
    end

    shared_examples "a failed sync that changes no status" do
      it "fails and leaves Belley out of service and the DINUM in service", :aggregate_failures do
        expect { call }.to raise_error(HubEE::Api::Error)

        expect(belley.reload).to be_inactive
        expect(dinum.reload).to be_active
      end
    end

    context "when HubEE answers with an error page" do
      before { stub_hubee_active_subscriptions(status: 502, body: "<html><body>502 Bad Gateway</body></html>") }

      it_behaves_like "a failed sync that changes no status"
    end

    context "when HubEE lists no active subscription" do
      before { stub_hubee_active_subscriptions(body: "[]") }

      it_behaves_like "a failed sync that changes no status"
    end

    context "when HubEE lists a subscription that carries no SIRET" do
      before { stub_hubee_active_subscriptions(body: [{"subscriber" => {}}].to_json) }

      it_behaves_like "a failed sync that changes no status"
    end

    context "when HubEE lists as many subscriptions as one answer can hold, so some may be cut off" do
      before do
        subscriptions = Array.new(HubEE::Api::ACTIVE_SUBSCRIPTIONS_LIMIT) { {"subscriber" => {"companyRegister" => "21010034300016"}} }

        stub_hubee_active_subscriptions(body: subscriptions.to_json)
      end

      it_behaves_like "a failed sync that changes no status"
    end
  end
end

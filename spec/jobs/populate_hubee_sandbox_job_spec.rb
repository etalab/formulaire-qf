require "rails_helper"

RSpec.describe PopulateHubEESandboxJob, type: :job do
  describe "#perform" do
    subject(:perform) { described_class.perform_now }

    let(:session) { HubEE::Api.new }

    before do
      stub_hubee
      allow(UploadQuotientFamilialToHubEE).to receive(:call).and_return(double(success?: true, folder: double(id: 1)))
    end

    it "adds data to each active subscription" do
      perform
      expect(UploadQuotientFamilialToHubEE).to have_received(:call).exactly(2).times
    end
  end
end

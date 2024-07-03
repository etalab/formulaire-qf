RSpec.describe PopulateHubEESandboxJob, type: :job do
  describe "#perform" do
    subject(:perform) { described_class.perform_now }

    let(:session) { HubEE::Api.new }

    before do
      stub_hubee
      allow(UploadQuotientFamilialToHubEE).to receive(:call).and_return(double(success?: true, folder: double(id: 1)))
    end
    context "when in production" do
      before do
        allow(Rails).to receive(:env).and_return(ActiveSupport::StringInquirer.new("production"))
      end

      it "does nothing" do
        perform
        expect(UploadQuotientFamilialToHubEE).not_to have_received(:call)
      end
    end

    context "when not in production" do
      it "adds data to each active subscription" do
        perform
        expect(UploadQuotientFamilialToHubEE).to have_received(:call).exactly(2).times
      end
    end
  end
end

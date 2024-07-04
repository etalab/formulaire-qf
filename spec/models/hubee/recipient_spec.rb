RSpec.describe HubEE::Recipient do
  subject(:recipient) { HubEE::Recipient.new(**params) }

  let(:params) do
    {
      siren: "21040107100019",
      branch_code: "04107",
      type: "SI",
    }
  end

  it { is_expected.to respond_to(:siren) }
  it { is_expected.to respond_to(:branch_code) }
  it { is_expected.to respond_to(:type) }

  describe "#initialize" do
    context "when all keywords are passed" do
      it "initializes a new recipient" do
        expect(recipient).to be_an_instance_of(HubEE::Recipient)
      end
    end

    context "when keywords with default values are missing" do
      let(:params) do
        {
          siren: "21040107100019",
          branch_code: "04107",
        }
      end

      it "initializes a new recipient" do
        expect(recipient).to be_an_instance_of(HubEE::Recipient)
      end
    end
  end

  describe "#[]" do
    it "returns the value at the specified index" do
      expect(recipient[:siren]).to eq("21040107100019")
    end
  end
end

RSpec.describe StoreQuotientFamilial, type: :organizer do
  let(:interactors) do
    [
      UploadQuotientFamilialToHubEE,
      CreateShipment,
    ]
  end

  it "setups the folder, sends it to HubEE and cleans afterwards" do
    expect(described_class).to organize interactors
  end

  describe ".call" do
    subject(:organizer) { described_class.call(**params) }

    let(:pivot_identity) { PivotIdentity.new(first_names: ["David"], last_name: "Heinemeier Hansson", birth_country: "99135", birthplace: nil, birthdate: Date.new(1979, 10, 15), gender: :male) }
    let(:params) do
      {
        quotient_familial:,
        pivot_identity:,
        collectivity:,
        user:,
      }
    end
    let(:quotient_familial) { FactoryBot.attributes_for(:quotient_familial_payload) }
    let(:collectivity) { create(:collectivity) }
    let(:user) { User.new(access_token: "a_real_token", sub: "a_real_sub") }

    before do
      allow(SecureRandom).to receive(:hex).and_return("abcdef1234567thiswontbeused")

      stub_hubee
    end

    it { is_expected.to be_a_success }

    it "creates a shipment" do
      expect { organizer }.to change(Shipment, :count).by(1)
    end
  end
end

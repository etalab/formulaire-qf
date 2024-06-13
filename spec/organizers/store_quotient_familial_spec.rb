require "rails_helper"

RSpec.describe StoreQuotientFamilial, type: :organizer do
  let(:interactors) do
    [
      UploadQuotientFamilialToHubEE,
      CreateShipment,
      ClearCurrentAttributes,
    ]
  end

  it "setups the folder, sends it to HubEE and cleans afterwards" do
    expect(described_class).to organize interactors
  end

  describe ".call" do
    subject(:organizer) { described_class.call(**params) }

    let(:folder) { build(:hubee_folder) }
    let(:identity) { PivotIdentity.new(first_names: ["David"], last_name: "Heinemeier Hansson", birth_country: "99135", birthplace: nil, birthdate: Date.new(1979, 10, 15), gender: :male) }
    let(:params) do
      {
        folder:,
        identity:,
        recipient:,
        user:,
      }
    end
    let(:recipient) { build(:hubee_recipient) }
    let(:user) { User.new(access_token: "a_real_token", sub: "a_real_sub") }

    before do
      allow(SecureRandom).to receive(:hex).and_return("abcdef1234567thiswontbeused")

      Current.user = "user"
      Current.pivot_identity = "pivot_identity"
      Current.quotient_familial = "quotient_familial"

      stub_hubee_token
      stub_hubee_create_folder
      stub_hubee_upload_attachment
      stub_hubee_mark_folder_complete
    end

    it { is_expected.to be_a_success }

    it "creates a shipment" do
      expect { organizer }.to change(Shipment, :count).by(1)
    end

    it "clears the user session" do
      expect { organizer }.to change { Current.user }.from("user").to(nil)
        .and change { Current.pivot_identity }.from("pivot_identity").to(nil)
        .and change { Current.quotient_familial }.from("quotient_familial").to(nil)
    end
  end
end

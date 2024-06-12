require "rails_helper"

RSpec.describe CreateShipment, type: :interactor do
  describe ".call" do
    subject(:interactor) { described_class.call(**params) }

    let(:folder) { instance_double("HubEE::Folder", id: "folder_uuid") }
    let(:params) do
      {
        folder:,
        user:,
      }
    end
    let(:user) { instance_double("User", sub: "real_uuid") }

    context "when the params are valid" do
      it { is_expected.to be_a_success }

      it "creates a shipment" do
        expect { interactor }.to change(Shipment, :count).by(1)
      end
    end
  end
end

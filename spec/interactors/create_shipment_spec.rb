require "rails_helper"

RSpec.describe CreateShipment, type: :interactor do
  describe ".call" do
    subject(:interactor) { described_class.call(**params) }

    let(:folder) { instance_double("HubEE::Folder", id: "folder_uuid") }
    let(:identity) { instance_double("PivotIdentity", sub: "real_uuid") }
    let(:params) do
      {
        identity:,
        folder:,
      }
    end

    context "when the params are valid" do
      it { is_expected.to be_a_success }

      it "creates a quotient familial request" do
        expect { interactor }.to change(Shipment, :count).by(1)
      end
    end
  end
end

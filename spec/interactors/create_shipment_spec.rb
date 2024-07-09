RSpec.describe CreateShipment, type: :interactor do
  describe ".call" do
    subject(:interactor) { described_class.call(**params) }

    let(:collectivity) { create(:collectivity) }
    let(:shipment) { Shipment.new(collectivity: collectivity) }
    let(:folder) { instance_double("HubEE::Folder", id: "folder_uuid") }
    let(:params) do
      {
        folder:,
        user:,
        shipment:,
      }
    end
    let(:user) { instance_double("User", sub: "real_uuid") }

    context "when the params are valid" do
      it { is_expected.to be_a_success }

      it "creates a shipment" do
        expect { interactor }.to change(Shipment, :count).by(1)
      end

      it "uses the reference in the context's shipment" do
        interactor
        expect(Shipment.last.reference).to eq shipment.reference
      end

      it "uses the id in the context's folder" do
        interactor
        expect(Shipment.last.hubee_folder_id).to eq folder.id
      end
    end
  end
end

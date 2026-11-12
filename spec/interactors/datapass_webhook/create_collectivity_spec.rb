RSpec.describe DatapassWebhook::CreateCollectivity, type: :interactor do
  describe ".call" do
    subject(:interactor) { described_class.call(organization:, service_provider: {"id" => "editor-1"}) }

    let(:organization) { Organization.new("13002526500013") }

    before { stub_insee }

    context "when the collectivity does not exist" do
      it "creates it out of service" do
        interactor

        expect(Collectivity.find_by!(siret: "13002526500013")).to be_inactive
      end
    end

    context "when the collectivity is already in service" do
      let!(:collectivity) do
        create(:collectivity, siret: "13002526500013", status: :active, name: "Old name", code_cog: "00000", departement: "00", editor: nil)
      end

      it "keeps it in service" do
        interactor

        expect(collectivity.reload).to be_active
      end

      it "updates what INSEE and DataPass know about it" do
        interactor

        expect(collectivity.reload).to have_attributes(
          name: "DIRECTION INTERMINISTERIELLE DU NUMERIQUE",
          code_cog: "75107",
          departement: "75",
          editor: "editor-1"
        )
      end
    end
  end
end

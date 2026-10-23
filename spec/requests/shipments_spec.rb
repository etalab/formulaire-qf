RSpec.describe "Shipments" do
  describe "GET /collectivites/:collectivity_id/confirmation/:reference" do
    it "answers not found when the reference matches no shipment" do
      collectivity = create(:collectivity)

      get collectivity_shipment_path(collectivity.siret, "INCONNU")

      expect(response).to have_http_status(:not_found)
    end
  end
end

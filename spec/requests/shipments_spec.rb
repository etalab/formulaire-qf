RSpec.describe "Shipments" do
  describe "GET /collectivites/:collectivity_id/confirmation/:reference" do
    it "answers not found when the reference matches no shipment" do
      collectivity = create(:collectivity)

      get collectivity_shipment_path(collectivity.siret, "INCONNU")

      expect(response).to have_http_status(:not_found)
    end

    it "answers not found when the reference belongs to another collectivity's shipment" do
      shipment = create(:shipment)
      other_collectivity = create(:collectivity, siret: "21640122400011")

      get collectivity_shipment_path(other_collectivity.siret, shipment.reference)

      expect(response).to have_http_status(:not_found)
    end

    it "answers not found when the siret matches no collectivity" do
      shipment = create(:shipment)

      get collectivity_shipment_path("21640122400011", shipment.reference)

      expect(response).to have_http_status(:not_found)
    end
  end
end

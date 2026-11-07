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

  describe "POST /collectivites/:collectivity_id/shipments" do
    let(:collectivity) { create(:collectivity, status: :active) }
    let(:folders_url) { "#{Settings.hubee.base_url}/teledossiers/v1/folders" }

    def send_after_france_connect
      get collectivity_path(collectivity.siret)
      get "/callback"
      post collectivity_shipments_path(collectivity.siret)
    end

    def hubee_folder_answer(reference)
      {status: 200, body: hubee_folder_payload(names: "TESTMAN_Johnny_Paul_René", reference:).to_json}
    end

    before do
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:france_connect] = OmniAuth::AuthHash.new(
        provider: :france_connect,
        credentials: {token: "token", id_token: "id_token"},
        extra: {raw_info: build(:france_connect_payload)}
      )
      allow(SecureRandom).to receive(:uuid).and_return("a-shipment-key-from-one-france-connect-login")
      allow(SecureRandom).to receive(:hex).and_call_original
      allow(SecureRandom).to receive(:hex).with(no_args).and_return("abcdef1234567thiswontbeused", "bcdef12345678thiswontbeused")
      stub_quotient_familial_v2(:msa_with_children)
      stub_hubee_token
      stub_request(:post, folders_url).to_return(hubee_folder_answer("ABCDEF1234567"), hubee_folder_answer("BCDEF12345678"))
      stub_hubee_upload_attachment
      stub_hubee_mark_folder_complete
      stub_hubee_delete_folder
    end

    after do
      OmniAuth.config.mock_auth.delete(:france_connect)
      OmniAuth.config.test_mode = false
    end

    context "when a second tap sends the form again with the same session" do
      before { send_after_france_connect }

      it "creates no second shipment nor HubEE folder" do
        expect { send_after_france_connect }.not_to change(Shipment, :count)
        expect(a_request(:post, folders_url)).to have_been_made.once
      end

      it "shows the first shipment's confirmation" do
        send_after_france_connect

        expect(response).to redirect_to(collectivity_shipment_path(collectivity.siret, "ABCDEF1234567"))
      end
    end

    context "when HubEE fails after creating the folder" do
      before do
        allow(Sentry).to receive(:capture_exception)
        stub_request(:put, %r{/teledossiers/v1/folders/.+/attachments/}).to_return(status: 502, body: "")
      end

      it "keeps no shipment" do
        expect { send_after_france_connect }.not_to change(Shipment, :count)
        expect(response).to redirect_to(collectivity_shipment_error_path(collectivity.siret))
      end

      it "asks for FranceConnect again on a second tap" do
        send_after_france_connect
        stub_hubee_upload_attachment

        expect { post collectivity_shipments_path(collectivity.siret) }.not_to change(Shipment, :count)
        expect(response).to redirect_to(collectivity_path(collectivity.siret))
      end
    end
  end
end

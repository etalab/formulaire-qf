describe SetupCurrentData, type: :interactor do
  describe ".call" do
    subject(:call) { described_class.call(session: session, params: params) }

    let(:collectivity) { create(:collectivity) }
    let(:session) { {:external_id => "12345", :redirect_uri => "https://real_uri", :portal_siret => collectivity.siret, "quotient_familial" => {"quotient_familial" => 2550}} }
    let(:params) { {collectivity_id: collectivity.siret} }

    before do
      Current.user = nil
      Current.pivot_identity = nil
      Current.original_pivot_identity = nil
      Current.quotient_familial = nil
      Current.collectivity = nil
      Current.external_id = nil
      Current.redirect_uri = nil
    end

    it "sets up current data" do
      expect { call }.not_to raise_error
    end

    it "sets up the current user" do
      expect { call }.to change { Current.user }.from(nil).to(instance_of(User))
    end

    it "sets up the current quotient familial" do
      expect { call }.to change { Current.quotient_familial }.from(nil).to({"quotient_familial" => 2550})
    end

    it "sets up the current collectivity" do
      expect { call }.to change { Current.collectivity }.from(nil).to(collectivity)
    end

    it "sets up the current external id" do
      expect { call }.to change { Current.external_id }.from(nil).to("12345")
    end

    it "sets up the current redirect uri" do
      expect { call }.to change { Current.redirect_uri }.from(nil).to("https://real_uri")
    end

    it "sets up the current pivot identity" do
      expect { call }.to change { Current.pivot_identity }.from(nil).to(instance_of(PivotIdentity))
    end

    context "when the portal values came for another collectivity" do
      let(:session) { {external_id: "12345", redirect_uri: "https://real_uri", portal_siret: "21040107100019"} }

      it "leaves the current external id empty" do
        call

        expect(Current.external_id).to be_nil
      end

      it "leaves the current redirect uri empty" do
        call

        expect(Current.redirect_uri).to be_nil
      end
    end

    context "with a session from FranceConnect" do
      let(:france_connect_payload) { build(:france_connect_payload) }
      let(:session) { {"raw_info" => france_connect_payload} }

      it "sets up the current original pivot identity" do
        expect { call }.to change { Current.original_pivot_identity }.from(nil).to(france_connect_payload.except("sub"))
      end
    end
  end
end

describe SetupCurrentData, type: :interactor do
  describe ".call" do
    subject(:call) { described_class.call(session: session, params: params) }

    let(:session) { {:external_id => "12345", :redirect_uri => "https://real_uri", "quotient_familial" => {"quotient_familial" => 2550}} }
    let(:collectivity) { create(:collectivity) }
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

    context "with an http return address" do
      let(:session) { {redirect_uri: "http://site.example"} }

      it "keeps it as the current redirect uri" do
        expect { call }.to change { Current.redirect_uri }.from(nil).to("http://site.example")
      end
    end

    context "with a javascript return address" do
      let(:session) { {redirect_uri: "javascript:alert(1)"} }

      it "leaves the current redirect uri empty" do
        expect { call }.not_to change { Current.redirect_uri }.from(nil)
      end
    end

    context "with a return address that is not a URL" do
      let(:session) { {redirect_uri: "http://exa mple.com"} }

      it "leaves the current redirect uri empty" do
        expect { call }.not_to change { Current.redirect_uri }.from(nil)
      end
    end

    it "sets up the current pivot identity" do
      expect { call }.to change { Current.pivot_identity }.from(nil).to(instance_of(PivotIdentity))
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

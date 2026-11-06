describe PortalSession do
  subject(:portal_session) { described_class.new(session) }

  let(:session) { {} }
  let(:siret_a) { "21040107100019" }
  let(:siret_b) { "21750001600019" }

  def params(values)
    ActionController::Parameters.new(values)
  end

  describe "#read" do
    it "is empty for a SIRET with nothing stored" do
      expect(portal_session.read(siret_a)).to eq({})
    end
  end

  describe "#write" do
    it "stores the values read back for the same SIRET" do
      portal_session.write(siret_a, params(external_id: "12345", redirect_uri: "https://a.example"))

      expect(portal_session.read(siret_a)).to eq("external_id" => "12345", "redirect_uri" => "https://a.example")
    end

    it "keeps another SIRET's values" do
      portal_session.write(siret_a, params(external_id: "12345", redirect_uri: "https://a.example"))
      portal_session.write(siret_b, params(external_id: "67890", redirect_uri: "https://b.example"))

      expect(portal_session.read(siret_a)).to eq("external_id" => "12345", "redirect_uri" => "https://a.example")
    end

    it "keeps the stored values when the new ones are blank" do
      portal_session.write(siret_a, params(external_id: "12345", redirect_uri: "https://a.example"))
      portal_session.write(siret_a, params(external_id: "", redirect_uri: ""))

      expect(portal_session.read(siret_a)).to eq("external_id" => "12345", "redirect_uri" => "https://a.example")
    end

    it "keeps the stored return link when only a new dossier number is given" do
      portal_session.write(siret_a, params(external_id: "12345", redirect_uri: "https://a.example"))
      portal_session.write(siret_a, params(external_id: "67890", redirect_uri: ""))

      expect(portal_session.read(siret_a)).to eq("external_id" => "67890", "redirect_uri" => "https://a.example")
    end

    it "leaves the session without portals when no portal value is given" do
      portal_session.write(siret_a, params(id: siret_a))

      expect(session).not_to have_key("portals")
    end

    it "drops keys other than the dossier number and the return link" do
      portal_session.write(siret_a, params(external_id: "12345", quotient_familial: "2550"))

      expect(portal_session.read(siret_a)).to eq("external_id" => "12345")
    end
  end

  describe "#kept_after_reset" do
    it "keeps the return link of the SIRET, without its dossier number" do
      portal_session.write(siret_a, params(external_id: "12345", redirect_uri: "https://a.example"))

      expect(described_class.new(portal_session.kept_after_reset(siret_a)).read(siret_a)).to eq("redirect_uri" => "https://a.example")
    end

    it "drops another SIRET's values" do
      portal_session.write(siret_a, params(redirect_uri: "https://a.example"))
      portal_session.write(siret_b, params(redirect_uri: "https://b.example"))

      expect(described_class.new(portal_session.kept_after_reset(siret_a)).read(siret_b)).to eq({})
    end

    it "keeps nothing when the SIRET has no return link" do
      portal_session.write(siret_a, params(external_id: "12345"))

      expect(portal_session.kept_after_reset(siret_a)).to eq({})
    end
  end
end

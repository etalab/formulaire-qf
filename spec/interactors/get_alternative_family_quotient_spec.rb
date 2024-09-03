describe GetAlternativeFamilyQuotient, type: :interactor do
  describe ".call" do
    subject(:call) { described_class.call(allocataire_number:, postal_code:, siret:) }

    let(:allocataire_number) { "2345678" }
    let(:postal_code) { "75001" }
    let(:siret) { "some_siret" }

    before do
      Current.quotient_familial = nil
      stub_quotient_familial_v1
    end

    it "calls the API" do
      expect { call }.not_to raise_error
    end

    it "sets up the quotient familial" do
      expect(call.success?).to be true
      expect(call.quotient_familial).to match(hash_including("quotientFamilial" => 1234, :version => "v1"))
    end

    context "when the API returns an error" do
      before do
        stub_quotient_familial_v1_with_error(:not_found, status: 404)
      end

      it "sets up a failure" do
        expect(call.success?).to be false
        expect(call.quotient_familial).to be_nil
        expect(call.message).to eq("Dossier allocataire inexistant. Le document ne peut être édité.")
      end
    end
  end
end

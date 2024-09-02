describe GetFamilyQuotient, type: :interactor do
  describe ".call" do
    subject(:call) { described_class.call(user:, siret:) }

    let(:user) { instance_double(User, access_token: "some_real_token") }
    let(:siret) { "some_siret" }

    before do
      Current.quotient_familial = nil
      stub_quotient_familial_v2(:cnaf_without_children)
    end

    it "calls the API" do
      expect { call }.not_to raise_error
    end

    it "sets up the quotient familial" do
      expect(call.success?).to be true
      expect(call.quotient_familial).to match(hash_including("quotientFamilial" => 2550))
    end

    context "when the API returns an error" do
      before do
        stub_quotient_familial_v2_with_error(:not_found, status: 404)
      end

      it "sets up a failure" do
        expect(call.success?).to be false
        expect(call.quotient_familial).to be_nil
        expect(call.message).to eq("Dossier allocataire inexistant. Le document ne peut être édité.")
      end
    end
  end
end

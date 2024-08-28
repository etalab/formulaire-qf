describe Api::CollectivitiesController, type: :controller do
  describe "GET index" do
    subject(:body) do
      get :index
      response.parsed_body
    end

    let(:collectivities) do
      (1..2).to_a.reverse.map do |i|
        create(:collectivity, name: "Collectivity n° #{i}")
      end
    end

    before do
      Collectivity.delete_all
      collectivities
    end

    it "returns the ordered collectivities" do
      expect(body.pluck("name")).to eq collectivities.sort_by(&:name).map(&:name)
    end

    it "serializes only the name siret and code_cog" do
      expect(body.first.keys).to eq %w[name siret code_cog]
    end

    context "with an inactive collectivity" do
      let!(:inactive_collectivity) { create(:collectivity, name: "The Inactive One", status: :inactive) }

      it "doesn't return the inactive collectivity" do
        expect(body.pluck("name")).not_to include("The Inactive One")
      end
    end
  end

  describe "POST create" do
    subject(:body) do
      request.headers["Authorization"] = authorization
      post :create, body: { cool: :story }
      response
    end
    
    let(:authorization) { "Bearer #{token}" }
    let(:token) { "the_test_key" }

    it "returns a 201" do
      expect(subject.code).to eq '201'
    end

    it "creates a collectivity" do
      expect{ subject }.to change{ Collectivity.count }.by 1
    end

    context "with no authorization header" do
      let(:authorization) { nil }

      it "returns a 401 Unauthorized" do
        expect(subject.code).to eq '401'
      end
    end

    context "with an empty bearer token" do
      let(:token) { nil }

      it "returns a 401 Unauthorized" do
        expect(subject.code).to eq '401'
      end
    end
  end
end

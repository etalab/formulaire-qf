describe Api::CollectivitiesController, type: :controller do
  describe "GET show" do
    let(:collectivity) { create(:collectivity) }

    it "returns the collectivity" do
      get :show, params: {id: collectivity.siret}
      expect(response.parsed_body["name"]).to eq collectivity.name
    end

    context "with an inactive collectivity" do
      let(:collectivity) { create(:collectivity, status: :inactive) }

      it "returns a 404" do
        get :show, params: {id: collectivity.siret}
        expect(response.code).to eq "404"
      end
    end

    context "with an unknown collectivity" do
      it "returns a 404" do
        get :show, params: {id: "12"}
        expect(response.code).to eq "404"
      end
    end
  end

  describe "GET index" do
    subject(:body) do
      get :index
      response.parsed_body
    end

    let(:collectivities) do
      (1..2).to_a.reverse.map do |i|
        create(:collectivity, name: "Collectivity n° #{i}", siret: "3560000001234#{i}")
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
      post :create, params: {collectivity: collectivity_payload}
      response
    end

    let(:collectivity_payload) { build(:collectivity).attributes }
    let(:authorization) { "Bearer #{token}" }
    let(:token) { "the_test_key" }

    before do
      Collectivity.delete_all
    end

    it "returns a 201" do
      expect(subject.code).to eq "201"
    end

    it "returns the collectivity" do
      id = JSON.parse(subject.body)["collectivity"]["id"]
      expect(id).to eq Collectivity.last.id
    end

    it "creates a collectivity" do
      expect { subject }.to change { Collectivity.count }.by 1
    end

    context "when the collectivity already exists" do
      before do
        Collectivity.create(**collectivity_payload)
      end

      it "returns a 409 Conflict" do
        expect(subject.code).to eq "409"
      end

      it "explains the error" do
        body = JSON.parse(subject.body)
        expect(body).to eq({errors: {siret: ["est déjà utilisé(e)"]}}.with_indifferent_access)
      end
    end

    context "with no name" do
      let(:collectivity_payload) { build(:collectivity, name: nil).attributes }

      it "returns a 422 Unprocessable Entity" do
        expect(subject.code).to eq "422"
      end

      it "explains the error" do
        body = JSON.parse(subject.body)
        expect(body).to eq({errors: {name: ["doit être rempli(e)"]}}.with_indifferent_access)
      end

      it "doesn't create a collectivity" do
        expect { subject }.not_to change { Collectivity.count }
      end
    end

    context "with no authorization header" do
      let(:authorization) { nil }

      it "returns a 401 Unauthorized" do
        expect(subject.code).to eq "401"
      end

      it "doesn't create a collectivity" do
        expect { subject }.not_to change { Collectivity.count }
      end
    end

    context "with an empty bearer token" do
      let(:token) { nil }

      it "returns a 401 Unauthorized" do
        expect(subject.code).to eq "401"
      end

      it "doesn't create a collectivity" do
        expect { subject }.not_to change { Collectivity.count }
      end
    end
  end
end

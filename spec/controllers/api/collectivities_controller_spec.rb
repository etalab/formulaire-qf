require "rails_helper"

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
end

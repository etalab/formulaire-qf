require "rails_helper"

describe SetupCurrentData, type: :interactor do
  describe ".call" do
    subject(:call) { described_class.call(session: session, params: params) }

    let(:session) { {"quotient_familial" => {"quotient_familial" => 2550}} }
    let(:collectivity) { create(:collectivity) }
    let(:params) { {collectivity_id: collectivity.siret} }

    before do
      Current.user = nil
      Current.pivot_identity = nil
      Current.quotient_familial = nil
      Current.collectivity = nil
    end

    it "sets up current data" do
      expect { call }.not_to raise_error
    end

    it "sets up the current user" do
      expect { call }.to change { Current.user }.from(nil).to(instance_of(User))
    end

    it "sets up the current pivot identity" do
      expect { call }.to change { Current.pivot_identity }.from(nil).to(instance_of(PivotIdentity))
    end

    it "sets up the current quotient familial" do
      expect { call }.to change { Current.quotient_familial }.from(nil).to({"quotient_familial" => 2550})
    end

    it "sets up the current collectivity" do
      expect { call }.to change { Current.collectivity }.from(nil).to(collectivity)
    end
  end
end

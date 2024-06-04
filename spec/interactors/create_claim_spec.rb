require "rails_helper"

RSpec.describe CreateClaim, type: :interactor do
  describe ".call" do
    subject(:interactor) { described_class.call(**params) }

    let(:folder) { instance_double("HubEE::Folder", id: "folder_uuid") }
    let(:identity) { instance_double("PivotIdentity", sub: "real_uuid") }
    let(:params) do
      {
        identity:,
        folder:,
      }
    end

    context "when the claim is created" do
      it { is_expected.to be_a_success }

      it "creates a claim" do
        expect { interactor }.to change(Claim, :count).by(1)
      end
    end
  end
end

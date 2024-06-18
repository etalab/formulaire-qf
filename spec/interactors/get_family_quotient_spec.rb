require "rails_helper"

describe GetFamilyQuotient, type: :interactor do
  describe ".call" do
    subject(:call) { described_class.call(user:, recipient:) }

    let(:user) { instance_double(User, access_token: "some_real_token") }
    let(:recipient) { "some_siret" }

    before do
      Current.quotient_familial = nil
      stub_qf_v2
    end

    it "calls the API" do
      expect { call }.not_to raise_error
    end

    it "sets up the current quotient familial" do
      expect(call.quotient_familial).to match(hash_including("quotientFamilial" => 2550))
    end
  end
end

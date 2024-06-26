require "rails_helper"

describe FranceConnect::AuthMapper, type: :mapper do
  describe ".normalize" do
    subject(:auth) { described_class.normalize(payload) }

    let(:expected_auth) do
      {
        sub: "some_real_sub",
      }
    end

    let(:payload) do
      {
        "sub" => "some_real_sub",
      }
    end

    it "returns a normalized hash" do
      expect(auth).to eq(expected_auth)
    end
  end
end

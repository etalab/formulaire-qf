require "rails_helper"

describe FranceConnect::AuthMapper, type: :mapper do
  describe ".normalize" do
    subject(:auth) { described_class.normalize(payload) }

    let(:expected_auth) do
      {
        access_token: "some_real_token",
        sub: "some_real_sub",
      }
    end

    let(:payload) do
      {
        "credentials" => {
          "token" => "some_real_token",
        },
        "extra" => {
          "raw_info" => {
            "sub" => "some_real_sub",
          },
        },
      }
    end

    it "returns a normalized hash" do
      expect(auth).to eq(expected_auth)
    end
  end
end

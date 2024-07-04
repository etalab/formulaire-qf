describe FranceConnect::IdentityMapper, type: :mapper do
  describe ".normalize" do
    subject(:pivot_identity) { described_class.normalize(payload) }

    let(:expected_pivot_identity) do
      {
        birth_country: "France",
        birthdate: Date.new(1980, 1, 1),
        birthplace: "Paris",
        first_names: ["John"],
        gender: :male,
        last_name: "Doe",
      }
    end

    let(:payload) do
      {
        "birthcountry" => "France",
        "birthplace" => "Paris",
        "birthdate" => "1980-01-01",
        "family_name" => "Doe",
        "given_name" => "John",
        "gender" => "male",
      }
    end

    it "returns a normalized hash" do
      expect(pivot_identity).to eq(expected_pivot_identity)
    end
  end
end

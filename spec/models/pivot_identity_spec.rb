describe PivotIdentity, type: :model do
  subject(:pivot_identity) { build(:pivot_identity) }

  describe "API" do
    it { is_expected.to respond_to(:birth_country) }
    it { is_expected.to respond_to(:birthdate) }
    it { is_expected.to respond_to(:birthplace) }
    it { is_expected.to respond_to(:first_names) }
    it { is_expected.to respond_to(:gender) }
    it { is_expected.to respond_to(:last_name) }
  end

  describe "#first_name" do
    subject(:first_name) { pivot_identity.first_name }

    it { is_expected.to eq("Fernand Henri Paul") }
  end

  describe "#to_h" do
    subject(:to_h) { pivot_identity.to_h }

    let(:expected_hash) do
      {
        birth_country: "France",
        birthdate: Date.new(1989, 10, 2),
        birthplace: "Marseille",
        first_name: "Fernand Henri Paul",
        gender: :male,
        last_name: "TESTBOY",
      }
    end

    it { is_expected.to eq(expected_hash) }
  end
end

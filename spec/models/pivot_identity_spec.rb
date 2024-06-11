require "rails_helper"

describe PivotIdentity, type: :model do
  subject(:pivot_identity) { described_class.new(**attributes) }

  let(:attributes) do
    {
      birth_country: "France",
      birthdate: Date.new(1980, 1, 1),
      birthplace: "Paris",
      first_names: ["John", "Peter"],
      gender: :male,
      last_name: "Doe",
    }
  end

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

    it { is_expected.to eq("John Peter") }
  end
end

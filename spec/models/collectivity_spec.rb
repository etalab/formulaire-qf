RSpec.describe Collectivity, type: :model do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:siret) }
  it { is_expected.to validate_presence_of(:code_cog) }
  it { is_expected.to validate_presence_of(:status) }

  it { is_expected.to define_enum_for(:status).with_values(active: "active", inactive: "inactive").backed_by_column_of_type(:string) }

  describe "validates the siret" do
    context "with a valid siret" do
      let(:collectivity) { build(:collectivity, siret: "13002526500013") }

      it "is valid" do
        expect(collectivity).to be_valid
      end
    end

    context "with an invalid siret" do
      let(:collectivity) { build(:collectivity, siret: "123") }

      it "is invalid" do
        expect(collectivity).to be_invalid
      end
    end
  end
end

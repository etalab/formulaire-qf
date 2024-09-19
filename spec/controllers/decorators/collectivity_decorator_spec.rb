RSpec.describe CollectivityDecorator do
  subject(:decorator) { CollectivityDecorator.new(collectivity) }

  let(:collectivity) { Collectivity.new(name: "Paris", departement: "75") }

  describe "#display_name" do
    subject { decorator.display_name }

    it { is_expected.to eq("Paris (75)") }
  end

  describe "#select_name" do
    subject { decorator.select_name }

    it { is_expected.to eq("(75) Paris") }
  end
end

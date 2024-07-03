RSpec.describe QuotientFamilialFacade do
  subject(:quotient_familial_facade) { described_class.new(quotient_familial) }

  describe "#empty?" do
    context "when there is data" do
      let(:quotient_familial) { FactoryBot.attributes_for(:quotient_familial_payload).deep_stringify_keys }

      it "returns false" do
        expect(subject.empty?).to be false
      end
    end

    context "when there is no data" do
      let(:quotient_familial) { nil }

      it "returns true" do
        expect(subject.empty?).to be true
      end
    end

    context "when there is no quotientFamilial value" do
      let(:quotient_familial) { {"regime" => "CNAF"} }

      it "returns true" do
        expect(subject.empty?).to be true
      end
    end
  end

  describe "#month_year" do
    before do
      Timecop.freeze(Date.new(1990, 2, 24))
    end

    after do
      Timecop.return
    end

    context "when there is data" do
      let(:quotient_familial) { FactoryBot.attributes_for(:quotient_familial_payload).deep_stringify_keys }

      it "makes a readable string of the month and year" do
        expect(subject.month_year).to eq "février 2024"
      end
    end

    context "when there is no data" do
      let(:quotient_familial) { nil }

      it "returns nil" do
        expect(subject.month_year).to be nil
      end
    end

    context "when there is a missing month and year" do
      let(:quotient_familial) { {"quotientFamilial" => 12, "annee" => nil, "mois" => nil} }

      it "uses the current month and year" do
        expect(subject.month_year).to eq "février 1990"
      end
    end
  end

  describe "#allocataires" do
    context "when there is data" do
      let(:quotient_familial) { FactoryBot.attributes_for(:quotient_familial_payload).deep_stringify_keys }

      it "returns a readable array of persons strings" do
        expect(subject.allocataires).to eq ["DUBOIS ANGELA, née le 24/08/1962"]
      end
    end

    context "when there is no data" do
      let(:quotient_familial) { nil }

      it "returns an empty array" do
        expect(subject.allocataires).to be_empty
      end
    end

    context "when there is no allocataires" do
      let(:quotient_familial) { {"quotientFamilial" => 12, "allocataires" => []} }

      it "returns an empty array" do
        expect(subject.allocataires).to be_empty
      end
    end
  end

  describe "#children" do
    context "when there is data" do
      let(:quotient_familial) { FactoryBot.attributes_for(:quotient_familial_payload).deep_stringify_keys }

      it "returns a readable array of persons strings" do
        expect(subject.children).to eq ["Dujardin Jean, né le 13/12/2016"]
      end
    end

    context "when there is no data" do
      let(:quotient_familial) { nil }

      it "returns an empty array" do
        expect(subject.children).to be_empty
      end
    end

    context "when there is no children" do
      let(:quotient_familial) { {"quotientFamilial" => 12, "children" => []} }

      it "returns an empty array" do
        expect(subject.children).to be_empty
      end
    end
  end
end

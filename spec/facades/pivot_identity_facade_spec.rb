require "rails_helper"

RSpec.describe PivotIdentityFacade do
  subject(:pivot_identity_facade) { described_class.new(pivot_identity) }

  let(:pivot_identity) { build(:pivot_identity) }

  describe "#empty?" do
    it "returns false when there is data" do
      expect(subject.empty?).to be false
    end

    context "when there is no data" do
      let(:pivot_identity) { nil }

      it "returns true" do
        expect(subject.empty?).to be true
      end
    end

    context "when there is no full_name value" do
      let(:pivot_identity) { build(:pivot_identity, last_name: nil) }

      it "returns true" do
        expect(subject.empty?).to be true
      end
    end
  end

  describe "#full_name" do
    it "makes a full name string when there is data" do
      expect(subject.full_name).to eq "TESTBOY Fernand Henri Paul"
    end

    context "when there is no data" do
      let(:pivot_identity) { nil }

      it "returns nil" do
        expect(subject.full_name).to eq nil
      end
    end

    context "when there is no last_name value" do
      let(:pivot_identity) { build(:pivot_identity, last_name: nil) }

      it "returns nil" do
        expect(subject.full_name).to eq nil
      end
    end
  end

  describe "birthdate_sentence" do
    it "makes a readable birthdate sentence when there is data" do
      expect(subject.birthdate_sentence).to eq "le 02/10/1989"
    end

    context "when there is no data" do
      let(:pivot_identity) { nil }

      it "returns nil" do
        expect(subject.birthdate_sentence).to eq nil
      end
    end

    context "when there is no birthdate" do
      let(:pivot_identity) { build(:pivot_identity, birthdate: nil) }

      it "returns a missing birthdate parenthesis" do
        expect(subject.birthdate_sentence).to eq "(Date de naissance manquante)"
      end
    end
  end

  describe "#full_sentence" do
    it "makes a readable sentence when there is data" do
      expect(subject.full_sentence).to eq "TESTBOY Fernand Henri Paul, né le 02/10/1989\nCode de ville de naissance : Marseille\nCode de pays de naissance : France"
    end

    context "when there is no data" do
      let(:pivot_identity) { nil }

      it "returns nil" do
        expect(subject.full_sentence).to eq nil
      end
    end
  end
end

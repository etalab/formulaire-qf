require "rails_helper"

RSpec.describe Shipment, type: :model do
  describe "validations" do
    subject { FactoryBot.build(:shipment) }

    it { is_expected.to validate_presence_of(:reference) }
    it { is_expected.to validate_uniqueness_of(:reference) }
  end

  it { is_expected.to define_enum_for(:hubee_status).with_values(pending: "pending", in_progress: "in_progress", done: "done", refused: "refused").backed_by_column_of_type(:string) }

  describe "assign_reference" do
    subject { described_class.new }

    it "generates a 13 random string in the reference" do
      expect(subject.reference.length).to eq 13
    end

    context "when the generated reference already exists" do
      let!(:shipment) { create(:shipment) }

      before do
        allow(SecureRandom).to receive(:hex).and_return(shipment.reference, "some_new_reference")
      end

      it "generates another reference" do
        subject.save
        expect(subject.reference).to eq "SOME_NEW_REFE"
      end
    end
  end
end

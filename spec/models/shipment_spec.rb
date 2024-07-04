RSpec.describe Shipment, type: :model do
  describe "factories" do
    it "has a valid factory" do
      expect(build(:shipment)).to be_valid
    end

    context "with an existing shipment created with the factory" do
      before { create(:shipment) }

      it "has a valid factory" do
        expect(build(:shipment)).to be_valid
      end
    end
  end

  describe "validations" do
    subject { FactoryBot.build(:shipment) }

    it { is_expected.to belong_to(:collectivity) }
    it { is_expected.to validate_presence_of(:reference) }
    it { is_expected.to validate_uniqueness_of(:reference) }
    it { is_expected.to validate_length_of(:reference).is_equal_to(13) }
  end

  it { is_expected.to define_enum_for(:hubee_status).with_values(pending: "pending", sent: "sent", si_received: "si_received", in_progress: "in_progress", done: "done", refused: "refused").backed_by_column_of_type(:string) }

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

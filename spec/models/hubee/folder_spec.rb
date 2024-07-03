RSpec.describe HubEE::Folder do
  subject(:folder) { HubEE::Folder.new(**params) }

  let(:params) do
    {
      applicant: "applicant",
      attachments: ["attachments"],
      cases: ["cases"],
      external_id: "external_id",
      process_code: "process_code",
      id: "1234",
    }
  end

  it { is_expected.to respond_to(:id) }
  it { is_expected.to respond_to(:applicant) }
  it { is_expected.to respond_to(:attachments) }
  it { is_expected.to respond_to(:cases) }
  it { is_expected.to respond_to(:external_id) }
  it { is_expected.to respond_to(:process_code) }

  describe "#initialize" do
    context "when all keywords are passed" do
      it "initializes a new folder" do
        expect(folder).to be_an_instance_of(HubEE::Folder)
      end
    end

    context "when keywords with default values are missing" do
      let(:params) do
        {
          applicant: "applicant",
          attachments: ["attachments"],
          cases: ["cases"],
          external_id: "external_id",
          process_code: "process_code",
        }
      end

      it "initializes a new folder" do
        expect(folder).to be_an_instance_of(HubEE::Folder)
      end
    end
  end

  describe "#[]" do
    it "returns the value at the specified index" do
      expect(folder[:applicant]).to eq("applicant")
    end
  end
end

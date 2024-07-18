RSpec.describe HubEE::CreateFolder, type: :interactor do
  subject(:interactor) { described_class.call(**params) }

  let(:params) do
    {
      folder:,
    }
  end

  describe ".call" do
    let(:attachments) { [json_attachment, xml_attachment, pdf_attachment] }
    let(:cases) { [build(:hubee_case)] }
    let(:expected_body) do
      an_object_having_attributes(
        id: "3fa85f64-5717-4562-b3fc-2c963f66afa6",
        attachments: [
          an_object_having_attributes(id: "a66abb0c-52d1-4e50-9195-22526fb7ce92"),
          an_object_having_attributes(id: "a66abb0c-52d1-4e50-9195-22526fb7ce93"),
          an_object_having_attributes(id: "a66abb0c-52d1-4e50-9195-22526fb7ce94"),
        ],
        cases: [
          an_object_having_attributes(id: "d7923df5-c071-400e-87b5-f0d01d539aa5"),
        ]
      )
    end
    let(:folder) { build(:hubee_folder, attachments: attachments, cases: cases) }
    let(:json_attachment) { build(:hubee_attachment, :with_file) }
    let(:pdf_attachment) { build(:hubee_attachment, :with_file, file_name: "quotient_familial_Heinemeier_Hansson_David.pdf", mime_type: "application/pdf", file_size: 3079) }
    let(:xml_attachment) { build(:hubee_attachment, :with_file, file_name: "FormulaireQF.xml", mime_type: "application/xml", file_size: 1543) }

    before do
      stub_hubee_token
      stub_hubee_create_folder
    end

    it "creates the folder" do
      expect(interactor.folder).to match(expected_body)
    end

    context "when hubee returns an error" do
      before do
        stub_hubee_create_folder_with_error
      end

      it "makes an interactor failure" do
        expect(interactor.success?).to be false
      end

      it "returns the error message in the context" do
        expect(interactor.message).to eq({"error" => "Something went wrong"})
      end
    end
  end

  describe "#rollback" do
    subject(:rollback) { interactor.rollback }

    let(:folder) { double(HubEE::Folder, id: folder_id) }
    let(:folder_id) { "folder_id" }
    let(:interactor) { described_class.new(**params) }
    let(:params) do
      {
        folder:,
        session:,
      }
    end
    let(:session) { double(HubEE::Api) }

    it "deletes the folder" do
      expect(session).to receive(:delete_folder).with(folder_id:)
      rollback
    end
  end
end

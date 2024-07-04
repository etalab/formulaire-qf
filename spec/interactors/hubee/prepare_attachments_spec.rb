RSpec.describe HubEE::PrepareAttachments, type: :interactor do
  subject(:interactor) { described_class.call(**params) }

  let(:attachments) { [] }
  let(:folder) { HubEE::Folder.new(applicant: double, cases: [], external_id: "exId", process_code: "FormulaireQF", attachments:) }
  let(:params) do
    {
      folder:,
    }
  end

  describe ".call" do
    let(:attachments) do
      [
        HubEE::Attachment.new(file_name: "FormulaireQF.json", mime_type: "application/json", type: "FormulaireQF", file_content: "content", recipients: []),
      ]
    end
    let(:expected_attachments) do
      [
        an_object_having_attributes(file: a_kind_of(File), file_size: 7),
      ]
    end

    it "exposes the attachments" do
      expect(interactor.folder.attachments).to match_array(expected_attachments)
    end

    it "returns a success result" do
      expect(interactor).to be_success
    end
  end

  describe "#rollback" do
    subject(:rollback) { interactor.rollback }

    let(:attachment) { HubEE::Attachment.new(file: Tempfile.create, file_name: "FormulaireQF.json", mime_type: "application/json", type: "FormulaireQF", file_content: "content", recipients: []) }
    let(:attachments) do
      [
        attachment,
      ]
    end
    let(:interactor) { described_class.new(**params) }

    it "closes the files" do
      expect { rollback }.to change { interactor.context.folder.attachments[0].file.closed? }.from(false).to(true)
    end
  end
end

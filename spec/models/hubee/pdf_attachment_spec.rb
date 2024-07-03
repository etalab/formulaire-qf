RSpec.describe HubEE::PdfAttachment, type: :model do
  describe "#write" do
    subject(:write) { pdf_attachment.write(file:) }

    let(:file) { Tempfile.create }
    let(:pdf_attachment) { described_class.new(file_content: "file content", file_name: "example.pdf", mime_type: "application/pdf", recipients: ["recipient"], type: "type", id: "1234", file_size: 42) }

    it "writes the file" do
      expect { write }.to change {
                            file.rewind
                            file.read
                          }
    end
  end
end

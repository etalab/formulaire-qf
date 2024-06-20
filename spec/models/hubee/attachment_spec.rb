require "rails_helper"

RSpec.describe HubEE::Attachment do
  subject(:attachment) { HubEE::Attachment.new(**params) }

  let(:file) { double(File) }
  let(:params) do
    {
      file_content: "file content",
      file_name: "example.txt",
      mime_type: "text/plain",
      recipients: ["recipient"],
      type: "type",
      id: "1234",
      file:,
      file_size: 42,
    }
  end

  it { is_expected.to respond_to(:id) }
  it { is_expected.to respond_to(:file) }
  it { is_expected.to respond_to(:file_content) }
  it { is_expected.to respond_to(:file_name) }
  it { is_expected.to respond_to(:file_size) }
  it { is_expected.to respond_to(:mime_type) }
  it { is_expected.to respond_to(:recipients) }
  it { is_expected.to respond_to(:type) }

  describe "#initialize" do
    context "when all keywords are passed" do
      it "initializes a new attachment" do
        expect(attachment).to be_an_instance_of(HubEE::Attachment)
      end
    end

    context "when keywords with default values are missing" do
      let(:params) do
        {
          file_content: "file content",
          file_name: "example.txt",
          mime_type: "text/plain",
          recipients: ["recipient"],
          type: "type",
        }
      end

      it "initializes a new attachment" do
        expect(attachment).to be_an_instance_of(HubEE::Attachment)
      end
    end
  end

  describe "#[]" do
    it "returns the value at the specified index" do
      expect(attachment[:file_name]).to eq("example.txt")
    end
  end

  describe "#close_file" do
    it "closes the file" do
      expect(file).to receive(:close)
      attachment.close_file
    end
  end

  describe "#write" do
    it "writes to the file" do
      expect(file).to receive(:write).with("file content")
      attachment.write(file:)
    end
  end
end

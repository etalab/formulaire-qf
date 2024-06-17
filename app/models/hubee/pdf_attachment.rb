module HubEE
  class PdfAttachment < Attachment
    def initialize(file_content:, file_name:, mime_type:, recipients:, type:, id: nil, file: nil, file_size: nil)
      super
    end

    def write(file:)
      file.binmode
      pdf = Prawn::Document.new
      pdf.text file_content.to_s
      pdf.render(file)
    end
  end
end

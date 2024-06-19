module HubEE
  class PdfAttachment < Attachment
    def write(file:)
      file.binmode
      pdf = Prawn::Document.new
      pdf.text file_content.to_s
      pdf.render(file)
    end
  end
end

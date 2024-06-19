class PrepareQuotientFamilialHubEEFolder < BaseInteractor
  def call
    context.folder = ::HubEE::Folder.new(**folder_params)
  end

  private

  def case_external_id
    @case_external_id ||= "#{external_id}-01"
  end

  def external_id
    # This random string is formatted following HubEE's requirements
    # so it can display nicely in their portal.
    @external_id ||= "Formulaire-QF-#{SecureRandom.hex[0...13].upcase}"
  end

  def folder_params
    {
      applicant: context.identity,
      attachments: [
        json_file,
        xml_file,
        pdf_file,
      ],
      cases: [
        external_id: case_external_id,
        recipient: context.recipient,
      ],
      external_id:,
      process_code:,
    }
  end

  def json_file
    ::HubEE::Attachment.new(
      file_name: "FormulaireQF.json",
      mime_type: "application/json",
      recipients: [case_external_id],
      type: process_code,
      file_content: shipment_data.to_json
    )
  end

  def pdf_file
    ::HubEE::PdfAttachment.new(
      file_name: "FormulaireQF.pdf",
      mime_type: "application/pdf",
      recipients: [case_external_id],
      type: process_code,
      file_content: shipment_data.to_s
    )
  end

  def process_code
    "FormulaireQF"
  end

  def shipment_data
    ShipmentData.new(external_id: "test", identite_pivot: context.identity, quotient_familial: context.quotient_familial)
  end

  def xml_file
    ::HubEE::Attachment.new(
      file_name: "FormulaireQF.xml",
      mime_type: "application/xml",
      recipients: [case_external_id],
      type: process_code,
      file_content: shipment_data.to_xml
    )
  end
end

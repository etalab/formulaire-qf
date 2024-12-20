class PrepareQuotientFamilialHubEEFolder < BaseInteractor
  def call
    context.recipient = HubEE::Recipient.new(siren: context.collectivity.siret, branch_code: context.collectivity.code_cog)
    context.shipment = Shipment.new(collectivity: context.collectivity)
    context.folder = ::HubEE::Folder.new(**folder_params)
  end

  private

  def case_external_id
    @case_external_id ||= "#{external_id}-01"
  end

  def external_id
    # This random string is formatted following HubEE's requirements
    # so it can display nicely in their portal.
    @external_id ||= "Formulaire-QF-#{context.shipment.reference}"
  end

  def folder_params
    {
      applicant: context.pivot_identity,
      attachments: [
        json_file,
        xml_file,
        pdf_file,
      ],
      cases: [
        kase,
      ],
      external_id:,
      process_code:,
    }
  end

  def kase
    ::HubEE::Case.new(
      external_id: case_external_id,
      recipient: context.recipient
    )
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
    file_name = "quotient_familial_#{context.pivot_identity.last_name}_#{context.pivot_identity.first_name}.pdf".gsub(" ", "_")
    ::HubEE::PdfAttachment.new(
      file_name:,
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
    ShipmentData.new(
      external_id: context.external_id,
      pivot_identity: context.pivot_identity,
      original_pivot_identity: context.original_pivot_identity,
      quotient_familial: context.quotient_familial
    )
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

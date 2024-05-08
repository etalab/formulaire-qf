class Hubee::PrepareFolder < BaseInteractor
  def call
    context.folder = ::Hubee::Folder.new(**folder_params)
  end

  private

  def case_external_id
    @case_external_id ||= "#{external_id}-01"
  end

  def external_id
    # HubEE's portal view greps 13 chars after two dashes
    @external_id ||= "Formulaire-QF-#{SecureRandom.hex[0...13].upcase}"
  end

  def folder_params
    {
      applicant: context.identity,
      attachments: [
        json_file,
        text_file,
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
    ::Hubee::Attachment.new(
      file_name: "FormulaireQF.json",
      mime_type: "application/json",
      recipients: [case_external_id],
      type: process_code,
      file_content: '{"identite": "pivot"}'
    )
  end

  def process_code
    "FormulaireQF"
  end

  def text_file
    ::Hubee::Attachment.new(
      file_name: "FormulaireQF.pdf",
      mime_type: "application/pdf",
      recipients: [case_external_id],
      type: process_code,
      file_content: "Identité pivot"
    )
  end
end

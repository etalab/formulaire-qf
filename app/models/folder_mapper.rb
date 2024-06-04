class FolderMapper
  extend HashMapper

  class AttachmentMapper
    extend HashMapper

    map from("file_name"), to("fileName")
    map from("type"), to("type"), default: "FormulaireQF"
    map from("file_size"), to("size")
    map from("mime_type"), to("mimeType")
    map from("recipients"), to("recipients")
  end

  map from("process_code"), to("processCode"), default: "FormulaireQF"
  map from("external_id"), to("externalId")
  map from("applicant/first_name"), to("applicant/firstName")
  map from("applicant/last_name"), to("applicant/lastName")
  map from("cases[0]/recipient/siren"), to("cases[0]/recipient/companyRegister")
  map from("cases[0]/recipient/branch_code"), to("cases[0]/recipient/branchCode")
  map from("cases[0]/recipient/type"), to("cases[0]/recipient/type"), default_value: "SI"
  map from("cases[0]/external_id"), to("cases[0]/externalId")
  map from("attachments"), to("attachments"), using: AttachmentMapper
end

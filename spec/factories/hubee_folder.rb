FactoryBot.define do
  factory :hubee_folder, class: Hubee::Folder do
    initialize_with { new(**attributes) }

    applicant { {first_name: "David", last_name: "Heinemeier Hansson"} }
    attachments { [build(:hubee_attachment, :with_file)] }
    cases { [recipient: build(:hubee_recipient), external_id: "case_id"] }
    external_id { "external_id" }
    process_code { "FormulaireQF" }
  end
end

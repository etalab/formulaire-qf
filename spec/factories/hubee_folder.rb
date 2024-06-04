FactoryBot.define do
  factory :hubee_folder, class: HubEE::Folder do
    initialize_with { new(**attributes) }

    applicant { {first_name: "David", last_name: "Heinemeier Hansson"} }
    attachments { [build(:hubee_attachment, :with_file)] }
    cases { [recipient: build(:hubee_recipient), external_id: "Formulaire-QF-ABCDEF1234567-01"] }
    external_id { "Formulaire-QF-ABCDEF1234567" }
    process_code { "FormulaireQF" }
  end
end

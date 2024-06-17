FactoryBot.define do
  factory :hubee_attachment, class: HubEE::Attachment do
    initialize_with { new(**attributes) }

    file_content { "{\"first_name\":\"David\"}" }
    file_name { "FormulaireQF.json" }
    mime_type { "application/json" }
    recipients { ["Formulaire-QF-ABCDEF1234567-01"] }
    type { "FormulaireQF" }

    trait :with_file do
      file do
        Tempfile.create.tap do |file|
          file.write(file_content)
          file.rewind
        end
      end

      file_size { 683 }
    end
  end
end

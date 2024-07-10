FactoryBot.define do
  factory :hubee_case, class: HubEE::Case do
    initialize_with { new(**attributes) }

    external_id { "Formulaire-QF-ABCDEF1234567-01" }
    recipient { build(:hubee_recipient) }

    trait :with_id do
      id { "case_uuid" }
    end
  end
end

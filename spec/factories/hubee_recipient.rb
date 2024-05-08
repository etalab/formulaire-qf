FactoryBot.define do
  factory :hubee_recipient, class: Hubee::Recipient do
    initialize_with { new(**attributes) }

    siren { "123456789" }
    branch_code { "1234" }
    type { "SI" }
  end
end

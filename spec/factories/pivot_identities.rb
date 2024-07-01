FactoryBot.define do
  factory :pivot_identity do
    initialize_with { new(**attributes) }

    birth_country { "France" }
    birthdate { Date.new(1989, 10, 2) }
    birthplace { "Marseille" }
    first_names { %w[Fernand Henri Paul] }
    gender { :male }
    last_name { "TESTBOY" }
  end
end

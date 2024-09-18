FactoryBot.define do
  factory :original_pivot_identity, class: Hash do
    initialize_with { attributes.deep_stringify_keys }

    family_name { "TESTMAN" }
    given_name { "Johnny Paul René" }
    gender { "male" }
    birthdate { "1989-10-08" }
    birthplace { "75107" }
    birthcountry { "99100" }

    factory :france_connect_payload, class: Hash do
      sub { "some_sub" }
    end
  end
end

FactoryBot.define do
  factory :france_connect_payload, class: Hash do
    initialize_with { attributes.deep_stringify_keys }

    sub { "some_sub" }
    family_name { "TESTMAN" }
    given_name { "Johnny Paul René" }
    gender { "male" }
    birthdate { "1989-10-08" }
    birthplace { "75107" }
    birthcountry { "99100" }
  end
end

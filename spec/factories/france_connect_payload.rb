FactoryBot.define do
  factory :france_connect_payload, class: Hash do
    name { "TESTMAN" }
    email { "johnny.testman@email.com" }
    email_verified { true }
    nickname { "" }
    first_name { "Johnny Paul René" }
    last_name { "TESTMAN" }
    gender { "male" }
    image { "" }
    phone { "" }
  end
end

FactoryBot.define do
  factory :quotient_familial_request do
    sub { "uuid" }
    hubee_folder_id { "folder_uuid" }
  end
end

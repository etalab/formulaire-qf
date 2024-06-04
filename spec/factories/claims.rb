FactoryBot.define do
  factory :claim do
    sub { "uuid" }
    hubee_folder_id { "folder_uuid" }
  end
end

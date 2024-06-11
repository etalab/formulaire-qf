FactoryBot.define do
  factory :shipment do
    sub { "uuid" }
    hubee_folder_id { "folder_uuid" }
  end
end

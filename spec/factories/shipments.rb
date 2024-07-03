FactoryBot.define do
  factory :shipment do
    hubee_folder_id { "folder_uuid" }
    reference { "AAAAAAAAAAAAA" }
    hubee_status { :pending }
  end
end

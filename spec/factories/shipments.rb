FactoryBot.define do
  factory :shipment do
    hubee_folder_id { "folder_uuid" }
    hubee_status { :pending }
  end
end

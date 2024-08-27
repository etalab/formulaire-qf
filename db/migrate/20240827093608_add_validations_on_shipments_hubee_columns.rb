class AddValidationsOnShipmentsHubEEColumns < ActiveRecord::Migration[7.2]
  def change
    remove_index :shipments, :hubee_case_id
    add_index :shipments, :hubee_case_id, unique: true
    add_index :shipments, :hubee_folder_id, unique: true
  end
end

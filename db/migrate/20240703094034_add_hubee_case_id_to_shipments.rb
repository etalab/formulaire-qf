class AddHubEECaseIdToShipments < ActiveRecord::Migration[7.1]
  def change
    add_column :shipments, :hubee_case_id, :string
    add_index :shipments, :hubee_case_id
  end
end

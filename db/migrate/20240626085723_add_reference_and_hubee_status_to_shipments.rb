class AddReferenceAndHubEEStatusToShipments < ActiveRecord::Migration[7.1]
  def change
    change_table :shipments, bulk: true do |table|
      table.string :reference
      table.string :hubee_status, default: "pending"
    end

    add_index :shipments, :hubee_status
    add_index :shipments, :reference
  end
end

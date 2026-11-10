class AddSessionKeyToShipments < ActiveRecord::Migration[8.1]
  def change
    add_column :shipments, :session_key, :string
    add_index :shipments, :session_key, unique: true
  end
end

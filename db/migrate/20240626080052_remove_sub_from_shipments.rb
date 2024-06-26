class RemoveSubFromShipments < ActiveRecord::Migration[7.1]
  def change
    remove_column :shipments, :sub, :string
  end
end

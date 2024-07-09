class AddCollectivityIdToShipments < ActiveRecord::Migration[7.1]
  def change
    add_reference :shipments, :collectivity, foreign_key: true
  end
end

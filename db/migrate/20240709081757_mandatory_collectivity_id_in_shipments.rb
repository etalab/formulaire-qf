class MandatoryCollectivityIdInShipments < ActiveRecord::Migration[7.1]
  def change
    change_column_null :shipments, :collectivity_id, false
  end
end

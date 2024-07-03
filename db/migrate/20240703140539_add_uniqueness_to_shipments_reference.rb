class AddUniquenessToShipmentsReference < ActiveRecord::Migration[7.1]
  def up
    change_column :shipments, :reference, :string, null: false
    remove_index :shipments, :reference
    add_index :shipments, :reference, unique: true
  end

  def down
    remove_index :shipments, :reference, unique: true
    add_index :shipments, :reference
  end
end

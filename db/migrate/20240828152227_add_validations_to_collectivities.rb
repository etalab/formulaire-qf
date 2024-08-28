class AddValidationsToCollectivities < ActiveRecord::Migration[7.2]
  def up
    change_table :collectivities, bulk: true do |t|
      t.index :siret, unique: true
      t.change_null :siret, false
      t.change_null :name, false
      t.change_null :code_cog, false
      t.change_null :status, false
    end
  end

  def down
    change_table :collectivities, bulk: true do |t|
      t.remove_index :siret
      t.change_null :siret, true
      t.change_null :name, true
      t.change_null :code_cog, true
      t.change_null :status, true
    end
  end
end

class CreateCollectivities < ActiveRecord::Migration[7.1]
  def change
    create_table :collectivities do |t|
      t.string :name
      t.string :siret
      t.string :code_cog
      t.string :status
      t.string :editor

      t.timestamps
    end
  end
end

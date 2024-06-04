class CreateClaims < ActiveRecord::Migration[7.1]
  def change
    create_table :claims do |t|
      t.string :sub
      t.string :hubee_folder_id

      t.timestamps
    end
  end
end

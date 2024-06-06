class CreateQuotientFamilialRequests < ActiveRecord::Migration[7.1]
  def change
    create_table :quotient_familial_requests do |t|
      t.string :sub
      t.string :hubee_folder_id

      t.timestamps
    end
  end
end

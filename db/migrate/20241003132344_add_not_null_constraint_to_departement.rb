class AddNotNullConstraintToDepartement < ActiveRecord::Migration[7.2]
  def change
    change_column_null :collectivities, :departement, false
  end
end

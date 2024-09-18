class AddDepartementToCollectivities < ActiveRecord::Migration[7.2]
  def change
    add_column :collectivities, :departement, :string

    Collectivity.reset_column_information

    Collectivity.find_each do |collectivity|
      collectivity.update!(departement: collectivity.code_cog[0..1])
    end
  end
end

class MigrateDepartementProductionCollectivities < ActiveRecord::Migration[7.2]
  def up
    return unless Rails.env.production?

    collectivities_fixes = [
      [1, "Hauteluce", "73"],
      [2, "Feurs", "42"],
      [5, "Luriecq", "42"],
      [3, "Saint-Pryvé-Saint-Mesmin", "45"],
      [8, "Cressensac-Sarrazac", "46"],
      [9, "Saramon", "32"],
      [10, "Redene", "29"],
      [11, "Chatel sur Moselle", "88"],
      [12, "Herlies", "59"],
      [13, "Latrape", "31"],
      [7, "Taninges", "74"],
      [6, "Roussennac", "12"],
      [4, "Communauté de Communes de Sézanne Sud-Ouest Marnais", "51"],
      [14, "Doussard", "74"],
    ]
    collectivities_fixes.each do |fix|
      collectivity = Collectivity.find(fix[0])
      collectivity.update!(name: fix[1], departement: fix[2])
    end

    saramon = Collectivity.find(9)
    saramon.update!(code_cog: "32412")
  end

  def down
  end
end

class MigrateDepartementProductionCollectivities < ActiveRecord::Migration[7.2]
  def up
    return unless Rails.env.production?

    collectivities_fixes = [
      ["21730132400018", "Hauteluce", "73"],
      ["21420094100018", "Feurs", "42"],
      ["21420126100010", "Luriecq", "42"],
      ["21450298100019", "Saint-Pryvé-Saint-Mesmin", "45"],
      ["20008227900015", "Cressensac-Sarrazac", "46"],
      ["21320412600014", "Saramon", "32"],
      ["21290234000018", "Redene", "29"],
      ["21880094400017", "Chatel sur Moselle", "88"],
      ["21590303000017", "Herlies", "59"],
      ["21310280900018", "Latrape", "31"],
      ["21740276700016", "Taninges", "74"],
      ["21120206400013", "Roussennac", "12"],
      ["20006683500014", "Communauté de Communes de Sézanne Sud-Ouest Marnais", "51"],
      ["21740104100017", "Doussard", "74"],
    ]
    collectivities_fixes.each do |(siret, name, departement)|
      collectivity = Collectivity.find_by(siret:)
      next unless collectivity
      collectivity.update!(name:, departement:)
    end

    saramon = Collectivity.find_by(siret: "21320412600014")
    saramon&.update!(code_cog: "32412")
  end

  def down
  end
end

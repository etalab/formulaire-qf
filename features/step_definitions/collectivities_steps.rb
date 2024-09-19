Soit("l'existence de la collectivité de Majastres") do
  Collectivity.find_by(siret: "21040107100019") ||
    FactoryBot.create(:collectivity, name: "Majastres", siret: "21040107100019", code_cog: "04107", status: :active, departement: "04")
end

Soit("l'existence de la collectivité inactive de Sainville") do
  Collectivity.find_by(siret: "21280363900013") ||
    FactoryBot.create(:collectivity, name: "Sainville", siret: "21280363900013", code_cog: "28363", status: :inactive, departement: "28")
end

Quand("je me rend sur la page de {string}") do |name|
  collectivity = Collectivity.find_by!(name: name)
  visit collectivity_path(collectivity.siret)
end

Soit("l'existence de la collectivité de Majastres") do
  Collectivity.find_by(siret: "21040107100019") ||
    FactoryBot.create(:collectivity, name: "Majastres", siret: "21040107100019", code_cog: "04107", status: :active)
end

Soit("l'existence de la collectivité inactive de Sainville") do
  Collectivity.find_by(siret: "21280363900013") ||
    FactoryBot.create(:collectivity, name: "Sainville", siret: "21280363900013", code_cog: "28363", status: :inactive)
end

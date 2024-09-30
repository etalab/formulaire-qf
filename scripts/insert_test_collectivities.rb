collectivities = [
  {siret: "21040107100019", code_cog: "04107", name: "Majastres", departement: "04", status: :active},
  {siret: "11111111111111", code_cog: "11111", name: "Commune de HubEE - Test", departement: "11", status: :active},
  {siret: "11111111111112", code_cog: "11112", name: "Commune de HubEE - API", departement: "11", status: :active},
]

collectivities.each do |collectivity|
  c = Collectivity.new(**collectivity)
  c.save
end

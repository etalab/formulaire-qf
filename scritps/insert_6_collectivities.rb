collectivities = [
  {
    name: "Hauteluce (73)",
    siret: "21730132400018",
    code_cog: "73132",
    status: :active,
  },
  {
    name: "Feurs (42)",
    siret: "21420094100018",
    code_cog: "42094",
    status: :active,
  },
  {
    name: "Saint-Pryvé-Saint-Mesmin (45)",
    siret: "21450298100019",
    code_cog: "45298",
    status: :active,
  },
  {
    name: "Communauté de Communes de Sézanne Sud-Ouest Marnais (51)",
    siret: "24510097900054",
    code_cog: "00000",
    status: :active,
  },
  {
    name: "Luriecq (42)",
    siret: "21420126100010",
    code_cog: "42126",
    status: :active,
  },
  {
    name: "Roussennac (12)",
    siret: "21120206400013",
    code_cog: "12206",
    status: :active,
  },
]

collectivities.each do |collectivity|
  Collectivity.create(**collectivity)
end

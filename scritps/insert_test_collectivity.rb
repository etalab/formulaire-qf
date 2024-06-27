test_data = {
  name: "COMMUNE DE HUBEE",
  siret: "99999999999999",
  code_cog: "99999",
  status: :active,
}

Collectivity.create(**test_data)

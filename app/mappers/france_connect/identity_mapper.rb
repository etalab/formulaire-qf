module FranceConnect
  class IdentityMapper
    extend HashMapper

    map from("birthcountry"), to("birth_country")
    map from("birthdate"), to("birthdate") { |str| Date.strptime(str, "%Y-%m-%d") }
    map from("birthplace"), to("birthplace")
    map from("family_name"), to("last_name")
    map from("given_name"), to("first_names") { |str| str.split(" ") }
    map from("gender"), to("gender") { |str| str.to_sym }
  end
end

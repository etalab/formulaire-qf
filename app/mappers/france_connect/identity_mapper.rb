module FranceConnect
  class IdentityMapper
    extend HashMapper

    map from("extra/raw_info/birthcountry"), to("birth_country")
    map from("extra/raw_info/birthdate"), to("birthdate") { |str| Date.strptime(str, "%Y-%m-%d") }
    map from("extra/raw_info/birthplace"), to("birthplace")
    map from("extra/raw_info/family_name"), to("last_name")
    map from("extra/raw_info/given_name"), to("first_names") { |str| str.split(" ") }
    map from("extra/raw_info/gender"), to("gender") { |str| str.to_sym }
  end
end

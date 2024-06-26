module FranceConnect
  class AuthMapper
    extend HashMapper

    map from("sub"), to("sub")
    map from("family_name"), to("last_name")
    map from("given_name"), to("first_names")
  end
end

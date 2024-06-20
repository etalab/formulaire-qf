module FranceConnect
  class AuthMapper
    extend HashMapper

    map from("credentials/token"), to("access_token")
    map from("extra/raw_info/sub"), to("sub")
    map from("extra/raw_info/family_name"), to("last_name")
    map from("extra/raw_info/given_name"), to("first_names")
  end
end

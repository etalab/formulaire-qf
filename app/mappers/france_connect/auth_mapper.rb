module FranceConnect
  class AuthMapper
    extend HashMapper

    map from("credentials/token"), to("access_token")
    map from("extra/raw_info/sub"), to("sub")
  end
end

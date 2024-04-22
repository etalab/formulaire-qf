class PivotIdentity
  extend HashMapper

  attr_reader :auth, :data

  map from("info/birthdate"), to("birthdate") { |str| Date.strptime(str, "%Y-%m-%d") }
  map from("info/family_name"), to("family_name")
  map from("info/first_name"), to("first_names") { |str| str.split(" ") }
  map from("info/gender"), to("gender")
  map from("info/last_name"), to("last_name")
  map from("extra/raw_info/birthcountry"), to("birth_country")
  map from("extra/raw_info/birthplace"), to("birthplace")

  map from("credentials/token"), to("token")

  def initialize(recipient:, auth: {})
    @auth = auth
    @data = self.class.normalize(auth)
    @data[:recipient] = recipient
  end

  delegate :[], to: :data

  def token
    return "cnaf_qfv2" unless Rails.env.production?

    self[:token]
  end
end

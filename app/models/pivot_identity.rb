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
  map from("extra/raw_info/sub"), to("sub")

  map from("credentials/token"), to("token")

  def initialize(recipient:, auth: {})
    @auth = auth
    @data = self.class.normalize(auth)
    @data[:first_name] = first_name
    @data[:recipient] = recipient
  end

  delegate :[], to: :data

  def first_name
    (self[:first_names] || []).join(" ")
  end

  def last_name
    self[:last_name]
  end

  def authenticated?
    @auth.present?
  end

  def sub
    self[:sub]
  end

  def token
    self[:token]
  end
end

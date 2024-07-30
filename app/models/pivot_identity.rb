class PivotIdentity
  attr_reader :birth_country, :birthplace, :first_names, :gender, :last_name

  class NilBirthdate
    def year = nil

    def month = nil

    def day = nil

    def strftime(*) = ""

    def blank? = true
  end

  def initialize(birth_country: nil, birthdate: nil, birthplace: nil, first_names: [], gender: nil, last_name: nil)
    @birth_country = birth_country
    @birthdate = birthdate
    @birthplace = birthplace
    @first_names = first_names
    @gender = gender
    @last_name = last_name
  end

  def [](key)
    public_send(key)
  end

  def birthdate
    return @birthdate if @birthdate

    NilBirthdate.new
  end

  def first_name
    first_names.join(" ")
  end

  def to_h
    {
      birth_country:,
      birthdate:,
      birthplace:,
      first_name:,
      gender:,
      last_name:,
    }
  end
end

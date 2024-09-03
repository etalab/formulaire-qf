class PivotIdentity
  attr_reader :birth_country, :birthdate, :birthplace, :first_names, :gender, :last_name

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

  def verify_quotient_familial(quotient_familial)
    birthdate_found_in_allocataires(quotient_familial)
  end

  def birthdate_found_in_allocataires(quotient_familial)
    return false if quotient_familial["allocataires"].blank?

    quotient_familial["allocataires"].find do |allocataire|
      allocataire_birthdate = "#{allocataire["jourDateDeNaissance"]}/#{allocataire["moisDateDeNaissance"]}/#{allocataire["anneeDateDeNaissance"]}"
      allocataire_birthdate == birthdate.strftime("%d/%m/%Y")
    end.present?
  end
end

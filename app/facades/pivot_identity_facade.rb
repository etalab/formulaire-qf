class PivotIdentityFacade
  delegate :birthplace, :birth_country, :gender, to: :@pivot_identity

  def initialize(pivot_identity)
    @pivot_identity = pivot_identity
  end

  def full_name
    [
      @pivot_identity.last_name,
      *@pivot_identity.first_names,
    ].join(" ")
  end

  def birthdate
    @pivot_identity.birthdate.strftime("%d/%m/%Y")
  end

  def full_sentence
    [
      "#{full_name}, né#{"e" if gender == :female} le #{birthdate}",
      "Code de ville de naissance : #{birthplace}",
      "Code de pays de naissance : #{birth_country}",
    ].join("\n")
  end
end

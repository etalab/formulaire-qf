class PivotIdentityFacade
  attr_reader :pivot_identity

  delegate :birthplace, :birth_country, :gender, to: :pivot_identity

  def initialize(pivot_identity)
    @pivot_identity = pivot_identity
  end

  def full_name
    return nil if pivot_identity.last_name.blank?

    [
      pivot_identity.last_name,
      *pivot_identity.first_names,
    ].join(" ")
  end

  def birthdate
    return nil if pivot_identity.birthdate.blank?
    pivot_identity.birthdate.strftime("%d/%m/%Y")
  end

  def full_sentence
    return I18n.t("errors.no_data") if full_name.blank? || birthdate.blank?

    [
      "#{full_name}, né#{"e" if gender == :female} le #{birthdate}",
      "Code de ville de naissance : #{birthplace}",
      "Code de pays de naissance : #{birth_country}",
    ].join("\n")
  end
end

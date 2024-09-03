class QuotientFamilialFacade
  attr_reader :quotient_familial

  def initialize(quotient_familial)
    @quotient_familial = quotient_familial.try(:with_indifferent_access)
  end

  def empty?
    quotient_familial.blank? || value.blank?
  end

  def value
    if v1?
      "< valeur masquée >"
    else
      quotient_familial["quotientFamilial"]
    end
  end

  def regime
    quotient_familial["regime"] || I18n.t("shipments.new.quotient_familial.all_regimes")
  end

  def month_year
    return nil if empty?

    if month_year_is_invalid
      month_number = Time.zone.today.strftime("%m").to_i
      year_number = Time.zone.today.strftime("%Y")
    else
      month_number = quotient_familial["mois"].to_i
      year_number = quotient_familial["annee"]
    end

    month = I18n.t("date.month_names")[month_number]
    "#{month} #{year_number}"
  end

  def allocataires
    return [] if empty? || quotient_familial["allocataires"].blank?
    quotient_familial["allocataires"].map { |allocataire| person_facade(allocataire) }
  end

  def children
    return [] if empty? || quotient_familial["enfants"].blank?
    quotient_familial["enfants"].map { |enfant| person_facade(enfant) }
  end

  private

  def month_year_is_invalid
    quotient_familial["mois"].to_i.zero? ||
      quotient_familial["annee"].to_i.zero?
  end

  def v1?
    quotient_familial["version"] == "v1"
  end

  def person_facade(person)
    if v1?
      person_v1_facade(person)
    else
      person_v2_facade(person)
    end
  end

  def person_v2_facade(person)
    nom_usage = if person["nomUsage"] && person["nomUsage"] != person["nomNaissance"]
      " (nom d'usage #{person["nomUsage"]})"
    end

    names = "#{person["nomNaissance"]}#{nom_usage} #{person["prenoms"]}"
    birthdate = "#{person["jourDateDeNaissance"]}/#{person["moisDateDeNaissance"]}/#{person["anneeDateDeNaissance"]}"

    "#{names}, né#{"e" if person["sexe"] == "F"} le #{birthdate}"
  end

  def person_v1_facade(person)
    birthdate = person["dateDeNaissance"].gsub(/(\d\d)(\d\d)(\d\d\d\d)/, '\1/\2/\3')

    "#{person["nomPrenom"]}, né#{"e" if person["sexe"] == "F"} le #{birthdate}"
  end
end

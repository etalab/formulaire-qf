class QuotientFamilialFacade
  attr_reader :quotient_familial

  def initialize(quotient_familial)
    @quotient_familial = quotient_familial
  end

  def empty?
    quotient_familial["quotientFamilial"].blank?
  end

  def error_message
    if quotient_familial["error"].present?
      quotient_familial["message"] || quotient_familial["reason"] || quotient_familial["error"]
    end
  end

  def quotient
    quotient_familial["quotientFamilial"]
  end

  def regime
    quotient_familial["regime"]
  end

  def month_year
    month_number = quotient_familial["mois"]
    return "" if month_number.blank?
    month = I18n.t("date.month_names")[month_number]
    "#{month} #{quotient_familial["annee"]}"
  end

  def allocataires
    return [] if quotient_familial["allocataires"].blank?
    quotient_familial["allocataires"].map { |allocataire| person_facade(allocataire) }
  end

  def children
    return [] if quotient_familial["enfants"].blank?
    quotient_familial["enfants"].map { |enfant| person_facade(enfant) }
  end

  private

  def person_facade(person)
    nom_usage = if person["nomUsage"] && person["nomUsage"] != person["nomNaissance"]
      " (nom d'usage #{person["nomUsage"]})"
    end

    names = "#{person["nomNaissance"]}#{nom_usage} #{person["prenoms"]}"
    birthdate = "#{person["jourDateDeNaissance"]}/#{person["moisDateDeNaissance"]}/#{person["anneeDateDeNaissance"]}"

    "#{names}, né#{"e" if person["sexe"] == "F"} le #{birthdate}"
  end
end

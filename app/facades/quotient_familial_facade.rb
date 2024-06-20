class QuotientFamilialFacade
  attr_reader :quotient_familial

  def initialize(quotient_familial)
    @quotient_familial = quotient_familial
  end

  def quotient
    quotient_familial["quotientFamilial"]
  end

  def regime
    quotient_familial["regime"]
  end

  def month_year
    month_number = quotient_familial["mois"]
    month = I18n.t("date.month_names")[month_number]
    "#{month} #{quotient_familial["annee"]}"
  end

  def allocataires
    quotient_familial["allocataires"].map { |allocataire| person_facade(allocataire) }
  end

  def children
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

class QuotientFamilialFacade
  attr_reader :quotient_familial

  def initialize(quotient_familial)
    @quotient_familial = quotient_familial
  end

  def empty?
    quotient_familial.blank? || value.blank?
  end

  def value
    quotient_familial["quotientFamilial"]
  end

  def regime
    quotient_familial["regime"] || I18n.t("pages.shipments.new.quotient_familial.all_regimes")
  end

  def month_year
    return nil if empty?
    month_number = quotient_familial["mois"] || Time.zone.today.strftime("%m").to_i
    year_number = quotient_familial["annee"] || Time.zone.today.strftime("%Y")
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

  def person_facade(person)
    nom_usage = if person["nomUsage"] && person["nomUsage"] != person["nomNaissance"]
      " (nom d'usage #{person["nomUsage"]})"
    end

    names = "#{person["nomNaissance"]}#{nom_usage} #{person["prenoms"]}"
    birthdate = "#{person["jourDateDeNaissance"]}/#{person["moisDateDeNaissance"]}/#{person["anneeDateDeNaissance"]}"

    "#{names}, né#{"e" if person["sexe"] == "F"} le #{birthdate}"
  end
end

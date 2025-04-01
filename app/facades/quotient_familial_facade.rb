class QuotientFamilialFacade
  attr_reader :quotient_familial

  def initialize(quotient_familial)
    @quotient_familial = Hash(quotient_familial).with_indifferent_access
  end

  def empty?
    quotient_familial.blank? || quotient_familial["detail"].present? || value.blank?
  end

  def value
    quotient_familial["quotient_familial"]["valeur"].to_i
  end

  def regime
    quotient_familial["quotient_familial"]["fournisseur"] || I18n.t("shipments.new.quotient_familial.all_regimes")
  end

  def month_year
    return nil if empty?

    if month_year_is_invalid
      month_number = Time.zone.today.strftime("%m").to_i
      year_number = Time.zone.today.strftime("%Y").to_i
    else
      month_number = quotient_familial["quotient_familial"]["mois"].to_i
      year_number = quotient_familial["quotient_familial"]["annee"].to_i
    end

    month = I18n.t("date.month_names")[month_number]
    "#{month} #{year_number}"
  end

  def allocataires
    return [] if empty? || quotient_familial["allocataires"].blank?
    quotient_familial["allocataires"].map { |allocataire| person_to_string(allocataire) }
  end

  def children
    return [] if empty? || quotient_familial["enfants"].blank?
    quotient_familial["enfants"].map { |enfant| person_to_string(enfant) }
  end

  private

  def month_year_is_invalid
    quotient_familial["quotient_familial"]["mois"].to_i.zero? ||
      quotient_familial["quotient_familial"]["annee"].to_i.zero?
  end

  def person_to_string(person)
    nom_usage = if person["nom_usage"] && person["nom_usage"] != person["nom_naissance"]
      " (nom d'usage #{person["nom_usage"]})"
    end

    names = "#{person["nom_naissance"]}#{nom_usage}"
    names = "#{names} #{person["prenoms"]}" if person["prenoms"]
    birthdate = "#{birthdate_day(person["date_naissance"])}/#{birthdate_month(person["date_naissance"])}/#{birthdate_year(person["date_naissance"])}"

    "#{names}, né#{"e" if person["sexe"] == "F"} le #{birthdate}"
  end

  def birthdate_day(birthdate)
    birthdate.split("-")[2]
  end

  def birthdate_month(birthdate)
    birthdate.split("-")[1]
  end

  def birthdate_year(birthdate)
    birthdate.split("-")[0]
  end
end

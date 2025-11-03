class ShipmentData
  attr_reader :external_id, :pivot_identity, :original_pivot_identity, :quotient_familial

  def initialize(pivot_identity:, original_pivot_identity:, quotient_familial:, external_id: nil)
    @external_id = external_id
    @pivot_identity = pivot_identity
    @original_pivot_identity = original_pivot_identity
    @quotient_familial = quotient_familial.with_indifferent_access
  end

  def to_h
    {
      external_id: external_id,
      pivot_identity: original_pivot_identity,
      quotient_familial_v3: quotient_familial,
      quotient_familial: convert_quotient_familial_v2(quotient_familial),
    }
  end

  delegate :to_json, to: :to_h
  delegate :to_xml, to: :to_h

  def to_s
    <<~TEXT
      Identifant éditeur (optionnel): #{external_id}

      Identité pivot:
        Code Insee pays de naissance: #{pivot_identity.birth_country}
        Code Insee lieu de naissance: #{pivot_identity.birthplace}
        Date de naissance: #{pivot_identity.birthdate.strftime("%d/%m/%Y")}
        Nom de naissance: #{pivot_identity.last_name}
        Prénoms: #{pivot_identity.first_names.join(" ")}
        Sexe: #{(pivot_identity.gender == :female) ? "F" : "M"}
      
      #{quotient_familial_text}
    TEXT
  end

  private

  def quotient_familial_text
    if quotient_familial.blank?
      <<~TEXT
        Quotient familial:
          ERREUR: #{I18n.t("shipments.qf_v2_error.title")}
      TEXT
    else
      [
        "Quotient familial:",
        "  Régime: #{quotient_familial["quotient_familial"]["fournisseur"]}",
        "  Année: #{quotient_familial["quotient_familial"]["annee"]}",
        "  Mois: #{quotient_familial["quotient_familial"]["mois"]}",
        "  Quotient familial: #{quotient_familial["quotient_familial"]["valeur"]}",
        "",
        "  Allocataires:",
        "",
        allocataire_text,
        "  Enfants:",
        "",
        enfants_text,
      ].join("\n")
    end
  end

  def allocataire_text
    people_text(quotient_familial["allocataires"])
  end

  def enfants_text
    people_text(quotient_familial["enfants"])
  end

  def people_text(people)
    return "Aucun\n\n" if people.blank?

    people.map { |person| person_text(person) }.join("\n")
  end

  def person_text(person)
    [
      names(person),
      "    Date de naissance: #{birthdate_day(person["date_naissance"])}/#{birthdate_month(person["date_naissance"])}/#{birthdate_year(person["date_naissance"])}",
      "    Sexe: #{person["sexe"]}",
      "",
    ].flatten.join("\n")
  end

  def names(person)
    if quotient_familial["version"] == "v1"
      "  - Noms et prénoms : #{person["nomPrenom"]}"
    else
      [
        "  - Nom de naissance: #{person["nom_naissance"]}",
        "    Nom d'usage: #{person["nom_usage"]}",
        "    Prénoms: #{person["prenoms"]}",
      ].join("\n")
    end
  end

  def convert_quotient_familial_v2(quotient_familial)
    {
      regime: quotient_familial["quotient_familial"]["fournisseur"],
      allocataires: convert_people_v2_format(quotient_familial["allocataires"]),
      enfants: convert_people_v2_format(quotient_familial["enfants"]),
      quotientFamilial: quotient_familial["quotient_familial"]["valeur"],
      annee: quotient_familial["quotient_familial"]["annee"],
      mois: quotient_familial["quotient_familial"]["mois"],
      version: "v2",
    }
  end

  def convert_people_v2_format(people)
    people.map { |person| convert_person_v2_format(person) }
  end

  def convert_person_v2_format(person)
    {
      nomNaissance: person["nom_naissance"],
      nomUsuel: person["nom_usage"],
      prenoms: person["prenoms"],
      anneeDateDeNaissance: person["date_naissance"][0..3],
      moisDateDeNaissance: person["date_naissance"][5..6],
      jourDateDeNaissance: person["date_naissance"][8..9],
      sexe: person["sexe"],
    }
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

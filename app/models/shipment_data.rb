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
      quotient_familial: quotient_familial,
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
          ERREUR: #{I18n.t("shipments.qf_v1_error.title")}
      TEXT
    else
      [
        "Quotient familial:",
        "  Régime: #{quotient_familial["regime"]}",
        "  Année: #{quotient_familial["annee"]}",
        "  Mois: #{quotient_familial["mois"]}",
        "  Quotient familial: #{quotient_familial["quotientFamilial"]}",
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
      "    Date de naissance: #{person["jourDateDeNaissance"]}/#{person["moisDateDeNaissance"]}/#{person["anneeDateDeNaissance"]}",
      "    Sexe: #{person["sexe"]}",
      "",
    ].flatten.join("\n")
  end

  def names(person)
    if quotient_familial["version"] == "v1"
      "  - Noms et prénoms : #{person["nomPrenom"]}"
    else
      [
        "  - Nom de naissance: #{person["nomNaissance"]}",
        "    Nom d'usage: #{person["nomUsuel"]}",
        "    Prénoms: #{person["prenoms"]}",
      ].join("\n")
    end
  end
end

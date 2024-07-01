class ShipmentData
  attr_reader :external_id, :pivot_identity, :quotient_familial

  def initialize(pivot_identity:, quotient_familial:, external_id: nil)
    @external_id = external_id
    @pivot_identity = pivot_identity
    @quotient_familial = quotient_familial.with_indifferent_access
  end

  def to_h
    {
      external_id: external_id,
      pivot_identity: {
        codePaysLieuDeNaissance: pivot_identity.birth_country,
        anneeDateDeNaissance: pivot_identity.birthdate.year,
        moisDateDeNaissance: pivot_identity.birthdate.month,
        jourDateDeNaissance: pivot_identity.birthdate.day,
        codeInseeLieuDeNaissance: pivot_identity.birthplace,
        prenoms: pivot_identity.first_names,
        sexe: (pivot_identity.gender == :female) ? "F" : "M",
        nomUsage: pivot_identity.last_name,
      },
      quotient_familial:,
    }
  end

  delegate :to_json, to: :to_h
  delegate :to_xml, to: :to_h

  def to_s
    <<~TEXT
      Identifant éditeur (optionnel): #{external_id}

      Identité pivot:
        - Code Insee pays de naissance: #{pivot_identity.birth_country}
        - Code Insee lieu de naissance: #{pivot_identity.birthplace}
        - Date de naissance: #{pivot_identity.birthdate.strftime("%d/%m/%Y")}
        - Nom de naissance: #{pivot_identity.last_name}
        - Prénoms: #{pivot_identity.first_names.join(" ")}
        - Sexe: #{(pivot_identity.gender == :female) ? "F" : "M"}
      
      #{quotient_familial_text}
    TEXT
  end

  private

  def quotient_familial_error
    # TODO : Factorise management of errors
    quotient_familial["message"] || quotient_familial["reason"] || quotient_familial["error"]
  end

  def quotient_familial_text
    if quotient_familial_error
      <<~TEXT
        Quotient familial:
          ERREUR: #{quotient_familial_error}
      TEXT
    else
      <<~TEXT
        Quotient familial:
          - Régime: #{quotient_familial["regime"]}
          - Année: #{quotient_familial["annee"]}
          - Mois: #{quotient_familial["mois"]}
          - Quotient familial: #{quotient_familial["quotientFamilial"]}
          - Allocataires:
          
          #{allocataire_text}
          
          - Enfants:
          
          #{enfants_text}
      TEXT
    end
  end

  def allocataire_text
    return "Aucun" if quotient_familial["allocataires"].blank?

    quotient_familial["allocataires"].map do |allocataire|
      <<~TEXT
        - Nom de naissance: #{allocataire["nomNaissance"]}
        - Nom d'usage: #{allocataire["nomUsage"]}
        - Prénoms: #{allocataire["prenoms"]}
        - Date de naissance: #{allocataire["jourDateDeNaissance"]}/#{allocataire["moisDateDeNaissance"]}/#{allocataire["anneeDateDeNaissance"]}
        - Sexe: #{allocataire["sexe"]}
 
      TEXT
    end.join("\n")
  end

  def enfants_text
    return "Aucun" if quotient_familial["enfants"].blank?

    quotient_familial["enfants"].map do |enfant|
      <<~TEXT
        - Nom de naissance: #{enfant["nomNaissance"]}
        - Nom d'usage: #{enfant["nomUsuel"]}
        - Prénoms: #{enfant["prenoms"]}
        - Date de naissance: #{enfant["jourDateDeNaissance"]}/#{enfant["moisDateDeNaissance"]}/#{enfant["anneeDateDeNaissance"]}
        - Sexe: #{enfant["sexe"]}
 
      TEXT
    end.join("\n")
  end
end

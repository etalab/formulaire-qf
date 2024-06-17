class ShipmentData
  attr_reader :external_id, :identite_pivot, :quotient_familial

  def initialize(identite_pivot:, quotient_familial:, external_id: nil)
    @external_id = external_id
    @identite_pivot = identite_pivot
    @quotient_familial = quotient_familial
  end

  def to_h
    {
      external_id: external_id,
      identite_pivot: {
        codePaysLieuDeNaissance: identite_pivot.birth_country,
        anneeDateDeNaissance: identite_pivot.birthdate.year,
        moisDateDeNaissance: identite_pivot.birthdate.month,
        jourDateDeNaissance: identite_pivot.birthdate.day,
        codeInseeLieuDeNaissance: identite_pivot.birthplace,
        prenoms: identite_pivot.first_names,
        sexe: (identite_pivot.gender == :female) ? "F" : "M",
        nomUsage: identite_pivot.last_name,
      },
      quotient_familial: {
        regime: quotient_familial["regime"],
        allocataires: quotient_familial["allocataires"].map do |allocataire|
          {
            nomNaissance: allocataire["nomNaissance"],
            nomUsage: allocataire["nomUsage"],
            prenoms: allocataire["prenoms"],
            anneeDateDeNaissance: allocataire["anneeDateDeNaissance"],
            moisDateDeNaissance: allocataire["moisDateDeNaissance"],
            jourDateDeNaissance: allocataire["jourDateDeNaissance"],
            sexe: allocataire["sexe"],
          }
        end,
        enfants: quotient_familial["enfants"].map do |enfant|
          {
            nomNaissance: enfant["nomNaissance"],
            nomUsuel: enfant["nomUsuel"],
            prenoms: enfant["prenoms"],
            anneeDateDeNaissance: enfant["anneeDateDeNaissance"],
            moisDateDeNaissance: enfant["moisDateDeNaissance"],
            jourDateDeNaissance: enfant["jourDateDeNaissance"],
            sexe: enfant["sexe"],
          }
        end,
        quotientFamilial: quotient_familial["quotientFamilial"],
        annee: quotient_familial["annee"],
        mois: quotient_familial["mois"],
      },
    }
  end

  delegate :to_json, to: :to_h
  delegate :to_xml, to: :to_h

  def to_s
    <<~TEXT
      Identifant éditeur (optionnel): #{external_id}

      Identité pivot:
        - Code Insee pays de naissance: #{identite_pivot.birth_country}
        - Code Insee lieu de naissance: #{identite_pivot.birthplace}
        - Date de naissance: #{identite_pivot.birthdate.strftime("%d/%m/%Y")}
        - Nom de naissance: #{identite_pivot.last_name}
        - Prénoms: #{identite_pivot.first_names.join(" ")}
        - Sexe: #{(identite_pivot.gender == :female) ? "F" : "M"}
      
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

  private

  def allocataire_text
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

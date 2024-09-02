FactoryBot.define do
  factory :quotient_familial_v2_payload, class: Hash do
    initialize_with { attributes.deep_stringify_keys }

    regime { "CNAF" }
    quotientFamilial { 2550 }
    annee { 2024 }
    mois { 2 }

    allocataires do
      [{
        nomNaissance: "DUBOIS",
        nomUsage: "DUBOIS",
        prenoms: "ANGELA",
        anneeDateDeNaissance: "1962",
        moisDateDeNaissance: "08",
        jourDateDeNaissance: "24",
        sexe: "F",
      }]
    end

    enfants do
      [{
        nomNaissance: "Dujardin",
        nomUsuel: "Dujardin",
        prenoms: "Jean",
        sexe: "M",
        anneeDateDeNaissance: "2016",
        moisDateDeNaissance: "12",
        jourDateDeNaissance: "13",
      }]
    end

    # adresse do
    #   {
    #     identite: "Madame ROUX JEANNE",
    #     complementInformation: nil,
    #     complementInformationGeographique: nil,
    #     numeroLibelleVoie: "1 RUE MONTORGUEIL",
    #     lieuDit: nil,
    #     codePostalVille: "75002 PARIS",
    #     pays: "FRANCE",
    #   }
    # end

    trait :cnaf_without_children do
      regime { "CNAF" }
      quotientFamilial { 2550 }
      annee { 2024 }
      mois { 2 }
      enfants { [] }

      allocataires do
        [{
          "nomNaissance" => "DUBOIS",
          "nomUsage" => "DUBOIS",
          "prenoms" => "ANGELA",
          "anneeDateDeNaissance" => "1962",
          "moisDateDeNaissance" => "08",
          "jourDateDeNaissance" => "24",
          "sexe" => "F",
        }]
      end
    end

    trait :msa_with_children do
      regime { "MSA" }
      quotientFamilial { 150 }
      annee { 2023 }
      mois { 5 }

      allocataires do
        [
          {
            nomNaissance: "ROUX",
            nomUsage: nil,
            prenoms: "JEANNE STEPHANIE",
            anneeDateDeNaissance: "1987",
            moisDateDeNaissance: "06",
            jourDateDeNaissance: "27",
            sexe: "F",
          },
          {
            nomNaissance: "ROUX",
            nomUsage: nil,
            prenoms: "LOIC NATHAN",
            anneeDateDeNaissance: "1979",
            moisDateDeNaissance: "05",
            jourDateDeNaissance: "19",
            sexe: "M",
          },
        ]
      end

      enfants do
        [
          {
            nomNaissance: "ROUX",
            nomUsage: nil,
            prenoms: "ALEXIS VINCENT",
            anneeDateDeNaissance: "2006",
            moisDateDeNaissance: "04",
            jourDateDeNaissance: "20",
            sexe: "M",
          },
          {
            nomNaissance: "ROUX",
            nomUsage: nil,
            prenoms: "FLEUR EDITH",
            anneeDateDeNaissance: "2004",
            moisDateDeNaissance: "04",
            jourDateDeNaissance: "20",
            sexe: "M",
          },
        ]
      end
    end
  end

  factory :quotient_familial_v2_error_payload, class: Hash do
    initialize_with { attributes.deep_stringify_keys }

    trait :not_found do
      error { "not_found" }
      reason { "Dossier allocataire inexistant. Le document ne peut être édité." }
      message { "Dossier allocataire inexistant. Le document ne peut être édité." }
    end
  end
end

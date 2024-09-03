FactoryBot.define do
  factory :quotient_familial_v2_payload, class: Hash do
    initialize_with { attributes.deep_stringify_keys }

    version { "v2" }
    regime { "CNAF" }
    quotientFamilial { 2550 }
    annee { 2024 }
    mois { 2 }

    allocataires do
      [{
        nomNaissance: "DUBOIS",
        nomUsuel: "DUBOIS",
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
          "nomUsuel" => "DUBOIS",
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
            nomUsuel: nil,
            prenoms: "JEANNE STEPHANIE",
            anneeDateDeNaissance: "1987",
            moisDateDeNaissance: "06",
            jourDateDeNaissance: "27",
            sexe: "F",
          },
          {
            nomNaissance: "ROUX",
            nomUsuel: nil,
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
            nomUsuel: nil,
            prenoms: "ALEXIS VINCENT",
            anneeDateDeNaissance: "2006",
            moisDateDeNaissance: "04",
            jourDateDeNaissance: "20",
            sexe: "M",
          },
          {
            nomNaissance: "ROUX",
            nomUsuel: nil,
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

  factory :quotient_familial_v1_payload, class: Hash do
    initialize_with { attributes.deep_stringify_keys }

    version { "v1" }
    quotientFamilial { 1234 }
    annee { 2022 }
    mois { 7 }

    allocataires do
      [
        {
          nomPrenom: "MARIE DUPONT",
          dateDeNaissance: "01031988",
          sexe: "F",
        },
        {
          nomPrenom: "JEAN DUPONT",
          dateDeNaissance: "01041990",
          sexe: "M",
        },
      ]
    end

    enfants do
      [
        {
          nomPrenom: "JACQUES DUPONT",
          dateDeNaissance: "01012010",
          sexe: "M",
        },
        {
          nomPrenom: "JEANNE DUPONT",
          dateDeNaissance: "01022012",
          sexe: "F",
        },
      ]
    end

    # adresse do
    #   {
    #     "identite" => "Monsieur JEAN DUPONT",
    #     "complementIdentite" => "APPARTEMENT 51",
    #     "complementIdentiteGeo" => "RESIDENCE DES COLOMBES",
    #     "numeroRue" => "42 RUE DE LA PAIX",
    #     "lieuDit" => "ILOTS DES OISEAUX",
    #     "codePostalVille" => "75001 PARIS",
    #     "pays" => "FRANCE",
    #   }
    # end
  end

  factory :quotient_familial_v1_error_payload, class: Hash do
    initialize_with { attributes.deep_stringify_keys }

    trait :not_found do
      error { "not_found" }
      reason { "Dossier allocataire inexistant. Le document ne peut être édité." }
      message { "Dossier allocataire inexistant. Le document ne peut être édité." }
    end
  end
end

FactoryBot.define do
  factory :quotient_familial_v2_payload, class: Hash do
    initialize_with { attributes.deep_stringify_keys }

    version { "v3" }

    allocataires do
      [{
        nom_naissance: "DUBOIS",
        nom_usage: "DUBOIS",
        prenoms: "ANGELA",
        date_naissance: "1962-08-24",
        sexe: "F",
      }]
    end

    enfants do
      [{
        nom_naissance: "Dujardin",
        nom_usage: "Dujardin",
        prenoms: "Jean",
        sexe: "M",
        date_naissance: "2016-12-13",
      }]
    end

    quotient_familial do
      {
        fournisseur: "CNAF",
        valeur: 2550,
        annee: 2024,
        mois: 2,
        annee_calcul: 2024,
        mois_calcul: 12,
      }
    end

    trait :cnaf_without_children do
      enfants { [] }

      allocataires do
        [{
          nom_naissance: "DUBOIS",
          nom_usage: "DUBOIS",
          prenoms: "ANGELA",
          date_naissance: "1962-08-24",
          sexe: "F",
        }]
      end

      quotient_familial do
        {
          fournisseur: "CNAF",
          valeur: 2550,
          annee: 2024,
          mois: 2,
          annee_calcul: 2024,
          mois_calcul: 12,
        }
      end
    end

    trait :msa_with_children do
      allocataires do
        [
          {
            nom_naissance: "ROUX",
            nom_usage: nil,
            prenoms: "JEANNE STEPHANIE",
            date_naissance: "1987-06-27",
            sexe: "F",
          },
          {
            nom_naissance: "ROUX",
            nom_usage: nil,
            prenoms: "LOIC NATHAN",
            date_naissance: "1979-05-19",
            sexe: "M",
          },
        ]
      end

      enfants do
        [
          {
            nom_naissance: "ROUX",
            nom_usage: nil,
            prenoms: "ALEXIS VINCENT",
            date_naissance: "2006-04-20",
            sexe: "M",
          },
          {
            nom_naissance: "ROUX",
            nom_usage: nil,
            prenoms: "FLEUR EDITH",
            date_naissance: "2004-04-20",
            sexe: "M",
          },
        ]
      end

      quotient_familial do
        {
          fournisseur: "MSA",
          valeur: 150,
          annee: 2023,
          mois: 5,
          annee_calcul: 2023,
          mois_calcul: 5,
        }
      end
    end
  end

  factory :quotient_familial_v2_error_payload, class: Hash do
    initialize_with { attributes.deep_stringify_keys }

    trait :not_found do
      title { "Allocataire non référencé" }
      detail { "L'allocataire n'est pas référencé auprès des caisses éligibles." }
      code { "35003" }
    end

    trait :not_found_cnaf do
      title { "Dossier allocataire absent CNAF" }
      detail { "Le dossier allocataire n'a pas été trouvé auprès de la CNAF." }
      code { "23003" }
    end
  end
end

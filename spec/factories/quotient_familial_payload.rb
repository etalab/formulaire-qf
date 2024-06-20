FactoryBot.define do
  factory :quotient_familial_payload, class: Hash do
    regime { "CNAF" }
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
    quotientFamilial { 2550 }
    annee { 2024 }
    mois { 2 }
  end
end

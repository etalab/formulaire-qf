class GetFamilyQuotient < BaseInteractor
  def call
    context.qf = {
      regime: "CNAF",
      enfants: [
        {
          nomNaissance: "ROUX",
          nomUsage: "ROUX",
          prenoms: "ALEXIS VINCENT",
          anneeDateDeNaissance: "2006",
          moisDateDeNaissance: "04",
          jourDateDeNaissance: "20",
          sexe: "M",
        },
      ],
      quotientFamilial: 2550,
      annee: 2024,
      mois: 2,
    }
  end
end

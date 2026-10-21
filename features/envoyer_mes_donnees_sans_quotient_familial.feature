# language: fr

Fonctionnalité: Ouvrir la page de transmission sans quotient familial récupéré
  Contexte:
    Etant donné l'existence de la collectivité de Majastres

  Scénario: Sans être identifié, j'ouvre la page de transmission de mes données
    Quand je me rends sur la page de transmission de "Majastres"
    Alors la page contient "Je m'identifie via FranceConnect"

  Scénario: Identifié avec FranceConnect sans quotient familial récupéré, j'ouvre la page de transmission de mes données
    Sachant que j'ai un compte sur FranceConnect
    Et que je n'ai pas de données de quotient familial ni chez la CAF ni chez MSA
    Et que je me rends sur la page d'accueil
    Et que je clique sur le premier "Débuter la démarche"
    Et que je sélectionne "(04) Majastres" pour "Nom de la collectivité"
    Et que je clique sur "Suivant"
    Et que je clique sur "S'identifier avec FranceConnect"
    Quand je me rends sur la page de transmission de "Majastres"
    Alors la page contient "Je m'identifie via FranceConnect"

  Scénario: Sans être identifié, j'envoie le formulaire de transmission de mes données
    Quand j'envoie le formulaire de transmission de "Majastres"
    Alors la page contient "Je m'identifie via FranceConnect"

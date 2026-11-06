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

  Scénario: Identifié avec FranceConnect pour une collectivité, j'ouvre la page de transmission d'une autre
    Etant donné l'existence de la collectivité de Barcelonnette
    Sachant que j'ai un compte sur FranceConnect
    Et que j'ai un quotient familial CAF sans enfants via France Connect
    Et que je me rends sur la page d'accueil
    Et que je clique sur le premier "Débuter la démarche"
    Et que je sélectionne "(04) Majastres" pour "Nom de la collectivité"
    Et que je clique sur "Suivant"
    Et que je clique sur "S'identifier avec FranceConnect"
    Et que la page contient "Je relis et transmets mes données à Majastres (04)"
    Quand je me rends sur la page de transmission de "Barcelonnette"
    Alors la page contient "Je m'identifie via FranceConnect"
    Et la page ne contient pas "Quotient familial de février 2024 : 2550"

  Scénario: Sans être identifié, j'envoie le formulaire de transmission de mes données
    Quand j'envoie le formulaire de transmission de "Majastres"
    Alors la page contient "Je m'identifie via FranceConnect"

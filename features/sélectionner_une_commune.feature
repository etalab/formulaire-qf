# language: fr

Fonctionnalité: Sélectionner une collectivité
  Contexte: 
    Etant donné l'existence de la collectivité de Majastres
    Etant donné l'existence de la collectivité inactive de Sainville
    Quand je me rends sur la page d'accueil
    Et que je clique sur le premier "Débuter la démarche"
    Et que la page contient "Choisir une collectivité"
  
  Scénario: Je sélectionne une collectivité
    Quand je sélectionne "(04) Majastres" pour "Nom de la collectivité"
    Et que je clique sur "Suivant"
    Alors la page contient "S'identifier avec FranceConnect"
    Et la page contient "Majastres (04)"

  Scénario: Déjà identifié avec FranceConnect, je choisis de nouveau la collectivité et dois m'identifier encore
    Sachant que j'ai un compte sur FranceConnect
    Et que j'ai un quotient familial CAF sans enfants via France Connect
    Et que je sélectionne "(04) Majastres" pour "Nom de la collectivité"
    Et que je clique sur "Suivant"
    Et que je clique sur "S'identifier avec FranceConnect"
    Et que la page contient "Je relis et transmets mes données à Majastres (04)"
    Quand je me rends sur la page d'accueil
    Et que je clique sur le premier "Débuter la démarche"
    Et que je sélectionne "(04) Majastres" pour "Nom de la collectivité"
    Et que je clique sur "Suivant"
    Alors la page contient "S'identifier avec FranceConnect"
    Et la page ne contient pas "Je relis et transmets mes données"

  Scénario: Je ne peux pas sélectionner une collectivité inactive
    Alors l'option "(04) Majastres" existe pour "Nom de la collectivité"
    Et l'option "Sainville" n'existe pas pour "Nom de la collectivité"

  Scénario: Je ne peux pas consulter la page d'une collectivité inactive
    Et que je me rend sur la page de "Sainville"
    Alors la page ne contient pas "Sainville"
    Et la page contient "Collectivité non trouvée"

  Scénario: Je ne peux pas ne sélectionner aucune collectivité
    Quand je clique sur "Suivant"
    Alors la page contient "Choisir une collectivité"

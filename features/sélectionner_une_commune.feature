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
    Alors la page contient "S’identifier avec FranceConnect"
    Et la page contient "Majastres (04)"

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
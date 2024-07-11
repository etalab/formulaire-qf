# language: fr

Fonctionnalité: Sélectionner une collectivité
  Contexte: 
    Etant donné l'existence de la collectivité de Majastres
    Etant donné l'existence de la collectivité inactive de Sainville
    Quand je me rends sur la page d'accueil
    Et que je clique sur le premier "Débuter la démarche"
  
  Scénario: Je sélectionne une collectivité
    Quand je sélectionne "Majastres" pour "Nom de la collectivité"
    Et que je clique sur "Suivant"
    Alors la page contient "S’identifier avec FranceConnect"
    Et la page contient "Majastres"

  Scénario: Je ne peux pas sélectionner une collectivité inactive
    Alors l'option "Majastres" existe pour "Nom de la collectivité"
    Et l'option "Sainville" n'existe pas pour "Nom de la collectivité"

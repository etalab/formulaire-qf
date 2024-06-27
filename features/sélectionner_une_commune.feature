# language: fr

Fonctionnalité: Sélectionner une commune
  Contexte: 
    Etant donné l'existence de la commune de Majastres
    Quand je me rends sur la page d'accueil
    Et que je clique sur le premier "Débuter la démarche"
  
  Scénario: Je sélectionne une commune
    Quand je sélectionne "Majastres" pour "Nom de la collectivité"
    Et que je clique sur "Suivant"
    Alors la page contient "S’identifier avec FranceConnect"
    Et la page contient "Majastres"
  

# language: fr

Fonctionnalité: Sélectionner une commune
  Contexte: 
    Quand je me rends sur la page d'accueil
    Et que je clique sur le premier "Débuter la démarche"
  
  Scénario: Je sélectionne une commune
    Quand je sélectionne "Pey" pour "Nom de votre commune"
    Et que je clique sur "Suivant"
    Alors la page contient "S’identifier avec FranceConnect"
    Et la page contient "Pey - 26410"
  
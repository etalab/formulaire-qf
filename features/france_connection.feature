# language: fr

Fonctionnalité: Sélectionner une commune
  Contexte: 
    Sachant que je suis un utilisateur qui peut se france connecter
    Et que je me rends sur la page d'accueil
    Et que je clique sur le premier "Débuter la démarche"
    Quand je sélectionne "Pey" pour "Nom de votre commune"
    Et que je clique sur "Suivant"
  
  Scénario: Je me france connecte
    Quand je clique sur "S’identifier avec FranceConnect"
    Alors la page contient "All good!"
  


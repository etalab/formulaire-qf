# language: fr

Fonctionnalité: Sélectionner une commune
  Contexte: 
    Sachant que je suis un utilisateur qui peut se france connecter
    Et que je me rends sur la page d'accueil
    Et que je clique sur le premier "Débuter la démarche"
    Et que je sélectionne "Pey" pour "Nom de votre commune"
    Et que je clique sur "Suivant"
    Et que je clique sur "S’identifier avec FranceConnect"
  
  Scénario: Je me france connecte
    Quand je clique sur "Transmettre mes informations"
    Alors la page contient "sent !"
  


# language: fr

Fonctionnalité: Consulter la page d'accueil
  Contexte: 
    Quand je me rends sur la page d'accueil
  
  Scénario: Je consulte la page d'accueil
    Alors la page contient "Transmettre son quotient familial à sa collectivité"

  Scénario: Je me rends sur la page de collectivités
    Etant donné l'existence de la commune de Majastres
    Quand je clique sur le premier "Débuter la démarche"
    Alors la page contient "Sélectionner votre commune"
    Alors la page contient "Majastres"

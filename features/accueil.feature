# language: fr

Fonctionnalité: Consulter la page d'accueil
  Contexte: 
    Quand je me rends sur la page d'accueil
  
  Scénario: Je consulte la page d'accueil
    Alors la page contient "Je transmets mon quotient familial à ma collectivité"

  Scénario: Je me rends sur la page de collectivités
    Etant donné l'existence de la collectivité de Majastres
    Quand je clique sur le premier "Débuter la démarche"
    Alors la page contient "Je choisis la collectivité"
    Alors la page contient "Majastres"

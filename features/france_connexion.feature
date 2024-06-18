# language: fr

Fonctionnalité: France connexion
  Contexte:
    Etant donné l'existence de la commune de Majastres
    Sachant que je suis un utilisateur qui peut se france connecter
    Et que je me rends sur la page d'accueil
    Et que je clique sur le premier "Débuter la démarche"
    Et que je sélectionne "Majastres" pour "Nom de votre commune"
    Et que je clique sur "Suivant"

  Scénario: Je me france connecte
    Quand je clique sur "S’identifier avec FranceConnect"
    Alors la page contient "All good!"



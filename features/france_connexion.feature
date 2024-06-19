# language: fr

Fonctionnalité: France connexion
  Contexte:
    Etant donné l'existence de la commune de Majastres
    Sachant que je suis un utilisateur de FranceConnect avec un quotient familial
    Et que je me rends sur la page d'accueil
    Et que je clique sur le premier "Débuter la démarche"
    Et que je sélectionne "Majastres" pour "Nom de votre commune"
    Et que je clique sur "Suivant"

  Scénario: Je me france connecte
    Quand je clique sur "S’identifier avec FranceConnect"
    Alors la page contient "Se déconnecter"
    Et la page contient "Voici les données qui seront transmises à Majastres"

  Scénario: Je me france connecte puis me déconnecte
    Quand je clique sur "S’identifier avec FranceConnect"
    Et que je clique sur "Se déconnecter"
    Alors la page contient "Débuter la démarche"
    Et la page ne contient pas "Se déconnecter"

  Scénario: Je recommence l'envoie de QF alors que je suis déjà connecté
    Et que je clique sur "S’identifier avec FranceConnect"
    Et que la page contient "Voici les données qui seront transmises à Majastres"
    Et que je me rends sur la page d'accueil
    Et que je clique sur le premier "Débuter la démarche"
    Et que je sélectionne "Majastres" pour "Nom de votre commune"
    Et que je clique sur "Suivant"
    Alors la page contient "Voici les données qui seront transmises à Majastres"




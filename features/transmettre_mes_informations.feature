# language: fr

Fonctionnalité: Transmettre mes informations
  Contexte: 
    Sachant que je suis un utilisateur de FranceConnect avec un quotient familial
    Etant donné l'existence de la commune de Majastres
    Et que hubee peut recevoir un dossier
    Et que je me rends sur la page d'accueil
    Et que je clique sur le premier "Débuter la démarche"
    Et que je sélectionne "Majastres" pour "Nom de votre commune"
    Et que je clique sur "Suivant"
    Et que je clique sur "S’identifier avec FranceConnect"
  
  Scénario: Je me france connecte
    Quand je clique sur "Transmettre mes informations"
    Alors la page contient "Vos informations ont bien été transmises à Majastres"
  


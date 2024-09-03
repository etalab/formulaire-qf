# language: fr

Fonctionnalité: France connexion
  Contexte:
    Etant donné l'existence de la collectivité de Majastres
    Sachant que j'ai un compte sur FranceConnect
    Et que j'ai un quotient familial CAF sans enfants via France Connect
    Et que je me rends sur la page d'accueil
    Et que je clique sur le premier "Débuter la démarche"
    Et que je sélectionne "Majastres" pour "Nom de la collectivité"
    Et que je clique sur "Suivant"

  Scénario: Je me france connecte
    Quand je clique sur "S’identifier avec FranceConnect"
    Alors la page contient "Se déconnecter"
    Et la page contient "Je relis et transmets mes données à Majastres"

  Scénario: Je me france connecte puis me déconnecte
    Quand je clique sur "S’identifier avec FranceConnect"
    Et que je clique sur "Se déconnecter"
    Alors la page contient "Débuter la démarche"
    Et la page ne contient pas "Se déconnecter"

  Scénario: Je recommence l'envoie de QF alors que je suis déjà connecté
    Et que je clique sur "S’identifier avec FranceConnect"
    Et que la page contient "Je relis et transmets mes données à Majastres"
    Et que je me rends sur la page d'accueil
    Et que je clique sur le premier "Débuter la démarche"
    Et que je sélectionne "Majastres" pour "Nom de la collectivité"
    Et que je clique sur "Suivant"
    Alors la page contient "Je relis et transmets mes données à Majastres"

  Scénario: Je n'ai pas FranceConnect
    Et que je clique sur "Consulter les alternatives"
    Alors la page contient "Comme alternative vous pouvez télécharger votre attestation"
    Et la page contient "Aidez nous à améliorer ce service"




# language: fr

Fonctionnalité: Gestion des erreurs API
  Contexte:
    Etant donné l'existence de la collectivité de Majastres
    Sachant que j'ai un compte sur FranceConnect
    Et que hubee peut recevoir un dossier
    Et que je me rends sur la page d'accueil
    Et que je clique sur le premier "Débuter la démarche"
    Et que je sélectionne "Majastres" pour "Nom de la collectivité"
    Et que je clique sur "Suivant"

  Scénario: Mes données de quotient familial sont indisponibles
    Et que mon quotient familial est indisponible
    Quand je clique sur "S’identifier avec FranceConnect"
    Alors la page contient "Dossier allocataire inexistant."
    Et la page contient "Alternative si vous êtes à la CAF"
    Et la page contient "Alternative si vous êtes à la MSA"

  Scénario: L'envoi de mes données à hubee a échoué
    Et que j'ai un quotient familial CAF sans enfants
    Et que l'envoi d'un dossier à hubee échouera
    Et que je clique sur "S’identifier avec FranceConnect"
    Quand je clique sur "Transmettre les données à la collectivité"
    Alors la page contient "L'envoi de votre quotient familial à votre collectivité n'a pas fonctionné"
    Et la page contient "Comme alternative vous pouvez télécharger votre attestation"
    Et la page contient "Votre attestation MSA sur le site de la MSA"
    Et la page contient "Votre attestation CAF sur le site de la CAF"

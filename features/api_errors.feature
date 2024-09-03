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

  Scénario: L'envoi de mes données à hubee a échoué
    Et que j'ai un quotient familial CAF sans enfants via France Connect
    Et que l'envoi d'un dossier à hubee échouera
    Et que je clique sur "S’identifier avec FranceConnect"
    Quand je clique sur "Transmettre les données à la collectivité"
    Alors la page contient "L'envoi de votre quotient familial à votre collectivité n'a pas fonctionné"
    Et la page contient "Comme alternative vous pouvez télécharger votre attestation"
    Et la page contient "Votre attestation MSA sur le site de la MSA"
    Et la page contient "Votre attestation CAF sur le site de la CAF"

  Scénario: Mes données de quotient familial sont indisponibles via France Connect
    Et que mon quotient familial via France Connect est indisponible
    Quand je clique sur "S’identifier avec FranceConnect"
    Alors la page contient "Dossier allocataire inexistant."
    Et la page contient "Je réessaye avec mon numéro d'allocataire CAF"
    Et la page contient "Alternative si vous êtes à la MSA"

  Scénario: Je récupère mes données de quotient familial via mon numéro d'allocataire
    Et que mon quotient familial via France Connect est indisponible
    Et que j'ai un quotient familial CAF via numéro d'allocataire
    Et que je clique sur "S’identifier avec FranceConnect"
    Et que la page contient "Dossier allocataire inexistant."
    Quand je remplis "Numéro d'allocataire CAF" avec "2345678"
    Et que je remplis "Code postal" avec "75001"
    Et que je clique sur "Retenter de récupérer mon quotient familial"
    Alors la page contient "Quotient familial de juillet 2022 : < valeur masquée >"
    Et la page contient "Allocataires : MARIE DUPONT, née le 01/03/1988 JEAN DUPONT, né le 01/04/1990"
    Et la page contient "Enfants : JACQUES DUPONT, né le 01/01/2010 JEANNE DUPONT, née le 01/02/2012"

  Scénario: Mes données de quotient familial sont indisponibles via mon numéro d'allocataire
    Et que mon quotient familial via France Connect est indisponible
    Et que mon quotient familial via numéro d'allocataire est indisponible
    Et que je clique sur "S’identifier avec FranceConnect"
    Et que la page contient "Dossier allocataire inexistant."
    Quand je remplis "Numéro d'allocataire CAF" avec "2345678"
    Et que je remplis "Code postal" avec "75001"
    Et que je clique sur "Retenter de récupérer mon quotient familial"
    Alors la page contient "Une erreur est survenue"
    Et la page contient "Dossier allocataire inexistant."

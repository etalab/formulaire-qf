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
    Et la page contient "Alternative si vous êtes à la CAF"
    Et la page contient "Alternative si vous êtes à la MSA"

  Scénario: Je récupère mes données de quotient familial via mon numéro d'allocataire
    Et que mon quotient familial via France Connect est indisponible
    Et que j'ai un quotient familial CAF via numéro d'allocataire
    Et que je clique sur "S’identifier avec FranceConnect"
    Et que la page contient "Dossier allocataire inexistant."
    Quand je remplis "Numéro d'allocataire CAF" avec "2345678"
    Et que je remplis "Code postal" avec "75001"
    Et que je clique sur "Retenter de récupérer mon quotient familial"
    Alors la page contient "Quotient familial de juillet 2022 : 1234"
    Et la page contient "Allocataires : ROUX JEANNE STEPHANIE, née le 27/06/1987 ROUX LOIC NATHAN, né le 19/05/1979"
    Et la page contient "Enfants : ROUX ALEXIS VINCENT, né le 20/04/2006 ROUX FLEUR EDITH, né le 20/04/2004"

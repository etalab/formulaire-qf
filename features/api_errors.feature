# language: fr

Fonctionnalité: Gestion des erreurs API
  Contexte:
    Etant donné l'existence de la collectivité de Majastres
    Et que hubee peut recevoir un dossier
    Et que je me rends sur la page d'accueil
    Et que je clique sur le premier "Débuter la démarche"
    Et que je sélectionne "Majastres" pour "Nom de la collectivité"
    Et que je clique sur "Suivant"

  Scénario: L'envoi de mes données à hubee a échoué
    Sachant que j'ai un compte sur FranceConnect
    Et que j'ai un quotient familial CAF sans enfants via France Connect
    Et que l'envoi d'un dossier à hubee échouera
    Et que je clique sur "S’identifier avec FranceConnect"
    Quand je clique sur "Transmettre les données à la collectivité"
    Alors la page contient "L'envoi de votre quotient familial à votre collectivité n'a pas fonctionné"
    Et la page contient "Une erreur est survenue"
    Et la page contient "Votre attestation MSA sur le site de la MSA"
    Et la page contient "Votre attestation CAF sur le site de la CAF"

  Scénario: Je n'ai pas de données de quotient familial ni chez la CAF ni chez MSA
    Sachant que j'ai un compte sur FranceConnect
    Et que je n'ai pas de données de quotient familial ni chez la CAF ni chez MSA
    Quand je clique sur "S’identifier avec FranceConnect"
    Alors la page contient "Une erreur est survenue"
    Et la page contient "Dossier allocataire inexistant."
    Et la page contient "Votre attestation CAF sur le site de la CAF."
    Et la page contient "Votre attestation MSA sur le site de la MSA."

  Scénario: J'ai une alternative quand mes données de quotient familial sont indisponibles via France Connect auprès de la CNAF
    Sachant que j'ai un compte sur FranceConnect
    Et que mon quotient familial via France Connect est indisponible auprès de la CNAF
    Quand je clique sur "S’identifier avec FranceConnect"
    Alors la page contient "Le dossier allocataire n'a pas été trouvé auprès de la CNAF."
    Et la page contient "Je réessaye avec mon numéro d'allocataire CAF :"

  Scénario: Je récupère mes données de quotient familial via mon numéro d'allocataire
    Sachant que j'ai un compte sur FranceConnect avec pour date de naissance "1989-10-09"
    Et que mon quotient familial via France Connect est indisponible auprès de la CNAF
    Et que j'ai un quotient familial CAF via numéro d'allocataire avec pour date de naissance "1989-10-09"
    Et que je clique sur "S’identifier avec FranceConnect"
    Et que la page contient "Le dossier allocataire n'a pas été trouvé auprès de la CNAF."
    Quand je remplis "Numéro d'allocataire CAF" avec "2345678"
    Et que je remplis "Code postal" avec "75001"
    Et que je clique sur "Retenter de récupérer mon quotient familial"
    Alors la page contient "Quotient familial de juillet 2022 : 1234"
    Et la page contient "Allocataires : MARIE DUPONT, née le 09/10/1989 JEAN DUPONT, né le 01/04/1990"
    Et la page contient "Enfants : JACQUES DUPONT, né le 01/01/2010 JEANNE DUPONT, née le 01/02/2012"

  Scénario: Je récupère mes données de quotient familial via un numéro allocataire dont la date de naissance ne correspond pas
    Sachant que j'ai un compte sur FranceConnect avec pour date de naissance "2012-08-25"
    Et que mon quotient familial via France Connect est indisponible auprès de la CNAF
    Et que j'ai un quotient familial CAF via numéro d'allocataire avec pour date de naissance "1989-10-09"
    Et que je clique sur "S’identifier avec FranceConnect"
    Et que la page contient "Le dossier allocataire n'a pas été trouvé auprès de la CNAF."
    Quand je remplis "Numéro d'allocataire CAF" avec "2345678"
    Et que je remplis "Code postal" avec "75001"
    Et que je clique sur "Retenter de récupérer mon quotient familial"
    Alors la page contient "Vous n'avez pas renseigné le bon numéro d'allocataire."
    Et la page contient "Je réessaye avec mon numéro d'allocataire CAF :"

  Scénario: Mes données de quotient familial sont indisponibles via mon numéro d'allocataire
    Sachant que j'ai un compte sur FranceConnect
    Et que mon quotient familial via France Connect est indisponible auprès de la CNAF
    Et que mon quotient familial via numéro d'allocataire est indisponible
    Et que je clique sur "S’identifier avec FranceConnect"
    Et que la page contient "Le dossier allocataire n'a pas été trouvé auprès de la CNAF."
    Quand je remplis "Numéro d'allocataire CAF" avec "2345678"
    Et que je remplis "Code postal" avec "75001"
    Et que je clique sur "Retenter de récupérer mon quotient familial"
    Alors la page contient "Une erreur est survenue"
    Et la page contient "Dossier allocataire inexistant."
    Et la page contient "Votre attestation CAF sur le site de la CAF."
    Et la page contient "Votre attestation MSA sur le site de la MSA."

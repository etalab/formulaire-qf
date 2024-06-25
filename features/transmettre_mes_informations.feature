# language: fr

Fonctionnalité: Transmettre mes informations
  Contexte:
    Etant donné l'existence de la commune de Majastres
    Sachant que j'ai un compte sur FranceConnect
    Et que hubee peut recevoir un dossier
    Et que je me rends sur la page d'accueil
    Et que je clique sur le premier "Débuter la démarche"
    Et que je sélectionne "Majastres" pour "Nom de votre commune"
    Et que je clique sur "Suivant"

  Scénario: Mes données FranceConnect sont correctement affichées
    Et que j'ai un quotient familial msa avec des enfants
    Quand je clique sur "S’identifier avec FranceConnect"
    Alors la page contient "TESTMAN Johnny Paul René, né le 08/10/1989"
    Et la page contient "ville de naissance : 75107"
    Et la page contient "pays de naissance : 99100"

  Scénario: Mes données de quotient familial sont correctement affichées
    Et que j'ai un quotient familial msa avec des enfants
    Quand je clique sur "S’identifier avec FranceConnect"
    Alors la page contient "Données de la MSA"
    Et la page contient "Quotient familial de mai 2023 : 150"
    Et la page contient "Allocataires : ROUX JEANNE STEPHANIE, née le 27/06/1987 ROUX LOIC NATHAN, né le 19/05/1979"
    Et la page contient "Enfants : ROUX ALEXIS VINCENT, né le 20/04/2006 ROUX FLEUR EDITH, né le 20/04/2004"
  
  Scénario: Mes données de quotient familial sont correctement affichées même sans enfants
    Et que j'ai un quotient familial CAF sans enfants
    Quand je clique sur "S’identifier avec FranceConnect"
    Alors la page contient "Données de la CNAF"
    Et la page contient "Quotient familial de février 2024 : 2550"
    Et la page contient "Allocataires : DUBOIS ANGELA, née le 24/08/1962"
    Et la page contient "Enfants : Aucun"

  Scénario: Mes données de quotient familial sont indisponibles
    Et que mon quotient familial est indisponible
    Quand je clique sur "S’identifier avec FranceConnect"
    Alors la page contient "Dossier allocataire inexistant."
  
  Scénario: Je transmet mes données
    Et que j'ai un quotient familial msa avec des enfants
    Et que je clique sur "S’identifier avec FranceConnect"
    Quand je clique sur "Transmettre mes informations"
    Alors la page contient "Vos informations ont bien été transmises à Majastres"

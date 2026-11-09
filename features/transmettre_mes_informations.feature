# language: fr

Fonctionnalité: Transmettre mes informations
  Contexte:
    Etant donné l'existence de la collectivité de Majastres
    Sachant que j'ai un compte sur FranceConnect
    Et que hubee peut recevoir un dossier
    Et que je me rends sur la page d'accueil
    Et que je clique sur le premier "Débuter la démarche"
    Et que je sélectionne "(04) Majastres" pour "Nom de la collectivité"
    Et que je clique sur "Suivant"

  Scénario: Mes données FranceConnect sont correctement affichées
    Et que j'ai un quotient familial MSA avec des enfants via France Connect
    Quand je clique sur "S'identifier avec FranceConnect"
    Alors la page contient "TESTMAN Johnny Paul René, né le 08/10/1989"
    Et la page contient "ville de naissance : 75107"
    Et la page contient "pays de naissance : 99100"

  Scénario: Mes données de quotient familial sont correctement affichées
    Et que j'ai un quotient familial MSA avec des enfants via France Connect
    Quand je clique sur "S'identifier avec FranceConnect"
    Alors la page contient "Données de la MSA"
    Et la page contient "Quotient familial de mai 2023 : 150"
    Et la page contient "Allocataires : ROUX JEANNE STEPHANIE, née le 27/06/1987 ROUX LOIC NATHAN, né le 19/05/1979"
    Et la page contient "Enfants : ROUX ALEXIS VINCENT, né le 20/04/2006 ROUX FLEUR EDITH, né le 20/04/2004"
  
  Scénario: Mes données de quotient familial sont correctement affichées même sans enfants
    Et que j'ai un quotient familial CAF sans enfants via France Connect
    Quand je clique sur "S'identifier avec FranceConnect"
    Alors la page contient "Données de la CNAF"
    Et la page contient "Quotient familial de février 2024 : 2550"
    Et la page contient "Allocataires : DUBOIS ANGELA, née le 24/08/1962"
    Et la page contient "Enfants : Aucun"
  
  Scénario: Je transmet mes données
    Et que j'ai un quotient familial MSA avec des enfants via France Connect
    Et que je clique sur "S'identifier avec FranceConnect"
    Quand je clique sur "Transmettre les données à la collectivité"
    Alors la page contient "Vos informations ont bien été transmises à Majastres (04)"
    Et la page contient la référence de ma demande
    Et la page ne contient pas "Retourner sur le site de ma collectivité"

  Scénario: Après avoir transmis mes données, je dois m'identifier de nouveau pour les transmettre encore
    Et que j'ai un quotient familial MSA avec des enfants via France Connect
    Et que je clique sur "S'identifier avec FranceConnect"
    Et que je clique sur "Transmettre les données à la collectivité"
    Et que la page contient "Vos informations ont bien été transmises à Majastres (04)"
    Quand je me rends sur la page de transmission de "Majastres"
    Alors la page contient "Je m'identifie via FranceConnect"

  Scénario: Après avoir transmis mes données, l'en-tête ne montre plus mon identité
    Et que j'arrive sur le formulaire depuis le portail de ma collectivité
    Et que j'ai un quotient familial MSA avec des enfants via France Connect
    Et que je clique sur "S'identifier avec FranceConnect"
    Et que la page contient "Johnny Paul René TESTMAN"
    Quand je clique sur "Transmettre les données à la collectivité"
    Alors la page contient "Vos informations ont bien été transmises à Majastres (04)"
    Et la page contient la référence de ma demande
    Et la page contient "Retourner sur le site de ma collectivité"
    Et la page ne contient pas "Johnny Paul René TESTMAN"
    Et la page ne contient pas "Se déconnecter"

  Scénario: Après un envoi échoué, l'en-tête ne montre plus mon identité
    Et que j'ai un quotient familial MSA avec des enfants via France Connect
    Et que hubee ne répond pas
    Et que je clique sur "S'identifier avec FranceConnect"
    Et que la page contient "Johnny Paul René TESTMAN"
    Quand je clique sur "Transmettre les données à la collectivité"
    Alors la page contient "L'envoi de votre quotient familial à votre collectivité n'a pas fonctionné"
    Et la page ne contient pas "Johnny Paul René TESTMAN"
    Et la page ne contient pas "Se déconnecter"

  @protection_contre_la_falsification
  Scénario: Après avoir transmis mes données, transmettre depuis un autre onglet resté ouvert redemande FranceConnect
    Et que j'ai un quotient familial MSA avec des enfants via France Connect
    Et que je clique sur "S'identifier avec FranceConnect"
    Et que je garde la page de transmission ouverte dans un autre onglet
    Et que je clique sur "Transmettre les données à la collectivité"
    Et que la page contient "Vos informations ont bien été transmises à Majastres (04)"
    Quand je transmets les données depuis l'autre onglet
    Alors la page contient "Je m'identifie via FranceConnect"
    Et la collectivité a reçu un seul envoi

  Scénario: Après avoir transmis mes données, renvoyer le formulaire ne les transmet pas une deuxième fois
    Et que j'ai un quotient familial MSA avec des enfants via France Connect
    Et que je clique sur "S'identifier avec FranceConnect"
    Et que je clique sur "Transmettre les données à la collectivité"
    Et que la page contient "Vos informations ont bien été transmises à Majastres (04)"
    Et que hubee peut recevoir un deuxième dossier
    Quand j'envoie le formulaire de transmission de "Majastres"
    Alors la page contient "Je m'identifie via FranceConnect"
    Et la collectivité a reçu un seul envoi
    Et hubee a reçu un seul dossier

  Scénario: Après un envoi échoué, je dois m'identifier de nouveau pour transmettre mes données
    Et que j'ai un quotient familial MSA avec des enfants via France Connect
    Et que hubee ne répond pas
    Et que je clique sur "S'identifier avec FranceConnect"
    Et que je clique sur "Transmettre les données à la collectivité"
    Et que la page contient "L'envoi de votre quotient familial à votre collectivité n'a pas fonctionné"
    Quand je me rends sur la page de transmission de "Majastres"
    Alors la page contient "Je m'identifie via FranceConnect"

  Scénario: Le navigateur ne garde pas la page de transmission, pour qu'un retour arrière ne la réaffiche pas
    Et que j'ai un quotient familial MSA avec des enfants via France Connect
    Quand je clique sur "S'identifier avec FranceConnect"
    Alors la page contient "Je relis et transmets mes données à Majastres (04)"
    Et le navigateur ne garde pas la page en cache

  Scénario: Je peux retourner sur le site de ma collectivité
    Et que j'arrive sur le formulaire depuis le portail de ma collectivité
    Et que j'ai un quotient familial MSA avec des enfants via France Connect
    Et que je clique sur "S'identifier avec FranceConnect"
    Quand je clique sur "Transmettre les données à la collectivité"
    Alors la page contient "Retourner sur le site de ma collectivité"

  Scénario: Après une première transmission, je transmets mes données à une deuxième collectivité
    Etant donné l'existence de la collectivité de Barcelonnette
    Et que j'ai un quotient familial MSA avec des enfants via France Connect
    Et que je clique sur "S'identifier avec FranceConnect"
    Et que je clique sur "Transmettre les données à la collectivité"
    Quand je me rend sur la page de "Barcelonnette"
    Et que je clique sur "S'identifier avec FranceConnect"
    Alors la page contient "Je relis et transmets mes données à Barcelonnette (04)"

  Scénario: Le dossier et le lien de retour du portail d'une collectivité ne suivent pas l'envoi à une autre
    Etant donné l'existence de la collectivité de Verifville
    Et que j'arrive sur le formulaire depuis le portail de ma collectivité
    Et que j'ai un quotient familial MSA avec des enfants via France Connect
    Et que je clique sur "S'identifier avec FranceConnect"
    Quand je me rends sur la page d'accueil
    Et que je clique sur le premier "Débuter la démarche"
    Et que je sélectionne "(13) Verifville" pour "Nom de la collectivité"
    Et que je clique sur "Suivant"
    Et que je clique sur "S'identifier avec FranceConnect"
    Et que je clique sur "Transmettre les données à la collectivité"
    Alors la page contient "Vos informations ont bien été transmises à Verifville (13)"
    Et la page ne contient pas "Retourner sur le site de ma collectivité"
    Et hubee n'a reçu aucun fichier contenant "DOSSIER-MAJASTRES"

  Scénario: La personne suivante qui choisit la même collectivité n'envoie pas le dossier du parent précédent
    Et que j'arrive sur le formulaire depuis le portail de ma collectivité
    Et que j'ai un quotient familial MSA avec des enfants via France Connect
    Et que je clique sur "S'identifier avec FranceConnect"
    Et que je clique sur "Transmettre les données à la collectivité"
    Et que hubee peut recevoir un deuxième dossier
    Et que j'ai un compte sur FranceConnect avec pour date de naissance "2010-01-01"
    Quand je me rends sur la page d'accueil
    Et que je clique sur le premier "Débuter la démarche"
    Et que je sélectionne "(04) Majastres" pour "Nom de la collectivité"
    Et que je clique sur "Suivant"
    Et que je clique sur "S'identifier avec FranceConnect"
    Et que je clique sur "Transmettre les données à la collectivité"
    Alors la page contient "Vos informations ont bien été transmises à Majastres (04)"
    Et hubee a reçu un fichier contenant "2010-01-01"
    Et hubee n'a reçu aucun fichier contenant à la fois "2010-01-01" et "DOSSIER-MAJASTRES"

  Scénario: Après un envoi échoué, le dossier du portail n'est pas gardé
    Et que j'arrive sur le formulaire depuis le portail de ma collectivité
    Et que j'ai un quotient familial MSA avec des enfants via France Connect
    Et que hubee ne répond pas
    Et que je clique sur "S'identifier avec FranceConnect"
    Et que je clique sur "Transmettre les données à la collectivité"
    Et que la page contient "L'envoi de votre quotient familial à votre collectivité n'a pas fonctionné"
    Et que hubee peut recevoir un dossier
    Quand je me rends sur la page d'accueil
    Et que je clique sur le premier "Débuter la démarche"
    Et que je sélectionne "(04) Majastres" pour "Nom de la collectivité"
    Et que je clique sur "Suivant"
    Et que je clique sur "S'identifier avec FranceConnect"
    Et que je clique sur "Transmettre les données à la collectivité"
    Alors la page contient "Vos informations ont bien été transmises à Majastres (04)"
    Et hubee n'a reçu aucun fichier contenant "DOSSIER-MAJASTRES"

  Scénario: Le dossier et le lien de retour du portail restent après être revenu sur la page de la collectivité
    Et que j'arrive sur le formulaire depuis le portail de ma collectivité
    Quand je me rend sur la page de "Majastres"
    Et que j'ai un quotient familial MSA avec des enfants via France Connect
    Et que je clique sur "S'identifier avec FranceConnect"
    Et que je clique sur "Transmettre les données à la collectivité"
    Alors la page contient "Retourner sur le site de ma collectivité"
    Et hubee a reçu un fichier contenant "DOSSIER-MAJASTRES"

  Scénario: Le dossier et le lien de retour du portail restent après être passé par le portail d'une autre collectivité
    Etant donné l'existence de la collectivité de Verifville
    Et que j'arrive sur le formulaire depuis le portail de ma collectivité
    Et que j'arrive sur le formulaire depuis le portail de Verifville
    Quand je me rend sur la page de "Majastres"
    Et que j'ai un quotient familial MSA avec des enfants via France Connect
    Et que je clique sur "S'identifier avec FranceConnect"
    Et que je clique sur "Transmettre les données à la collectivité"
    Alors le lien "Retourner sur le site de ma collectivité" mène à "http://real_uri"
    Et hubee a reçu un fichier contenant "DOSSIER-MAJASTRES"

  Scénario: Un dossier et un lien de retour vides n'effacent pas ceux du portail
    Et que j'arrive sur le formulaire depuis le portail de ma collectivité
    Quand j'arrive sur le formulaire depuis le portail de ma collectivité sans dossier ni lien de retour
    Et que j'ai un quotient familial MSA avec des enfants via France Connect
    Et que je clique sur "S'identifier avec FranceConnect"
    Et que je clique sur "Transmettre les données à la collectivité"
    Alors le lien "Retourner sur le site de ma collectivité" mène à "http://real_uri"
    Et hubee a reçu un fichier contenant "DOSSIER-MAJASTRES"

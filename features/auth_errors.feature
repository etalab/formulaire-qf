# language: fr

Fonctionnalité: Gestion des erreurs d'authentification
  Scénario: Je visualise un message d'erreur en cas de CSRF detecté
    Quand je me rends sur la page d'erreur d'authentification avec un CSRF detecté
    Alors la page contient "Erreur d'authentification"
    Et la page contient "Ce site a besoin des cookies de votre navigateur"

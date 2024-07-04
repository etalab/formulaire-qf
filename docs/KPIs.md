# Key Performance Indicators (KPI)

## Volume

- Pages vues sur [Matomo](https://stats.data.gouv.fr/index.php?module=CoreHome&action=index&idSite=305&period=day&date=yesterday#?period=day&date=2024-07-03&idSite=305&category=General_Visitors&subcategory=General_Overview)

- Nombre de connections via FranceConnect (Nombre de pages "Finir sa démarche" vues)

- Nombre de shipments en base de données
  - Group by status
  - Group by collectivity
- Nombre d'erreurs de récupération de QF dans [Sentry](https://errors.data.gouv.fr/organizations/sentry/issues/142509/events/?environment=production&project=29&referrer=issue-stream)

## Qualité

- Taux de connexion : Nombre de pages "Finir sa démarche" vues / Nombre de pages "Se connecter via FranceConnect" vues
- Taux de complétion : Nombre de shipments / Nombre de pages "Se connecter via FranceConnect" vues
- Taux de téléchargement : Nombre de shipments téléchargés par la collectivité / Nombre de shipments

# TODO 

Choper les chiffres via page title sur [Matomo](https://stats.data.gouv.fr/index.php?module=CoreHome&action=index&idSite=305&period=day&date=yesterday#?idSite=305&period=day&date=yesterday&category=General_Actions&subcategory=Actions_SubmenuPageTitles) pour :
- Nombre de pages "Finir sa démarche" vues
- Nombre de pages "Se connecter via FranceConnect" vues

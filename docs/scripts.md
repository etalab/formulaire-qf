# Scripts utiles

### Créer une commune de test

Utile notamment pour le setup en sandbox d'un éditeur.

```ruby
# On surcharge la dénomination pour éviter la dénomination INSEE officielle
class NamedOrga < SimpleDelegator
  def denomination
    "Commune test editeur AAA"
  end
end

# Une astuce pratique : utiliser le SIRET d'un établissement de la poste:
# https://annuaire-entreprises.data.gouv.fr/entreprise/la-poste-direction-generale-de-la-poste-356000000#etablissements
organization = NamedOrga.new(Organization.new("35600000038983"))
# Peu importe la valeur tant que c'est rempli
datapass_id = "12345"
# Utiliser son email ou un email jetable (yopmail etc)
collectivity_email = "jean-baptiste.feldis@beta.gouv.fr"
# Pour une commune sans éditeur :
service_provider = {}
# Pour une commune avec éditeur :
service_provider = {
  "id" => "identifiant_editeur_datapass",
  "siret" => "siret_editeur",
  "type" => "editor",
}

# Créé l'organisation sur HubEE, avec un abonnement FormulaireQF actif, créé la collectivité sur FQF
result = DatapassWebhook::SetupCollectivity.call(datapass_id:, organization:, collectivity_email:, service_provider:)
```

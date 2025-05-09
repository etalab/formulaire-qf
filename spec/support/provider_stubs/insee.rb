require_relative "../provider_stubs"

module ProviderStubs::INSEE
  def stub_insee
    stub_insee_token
    stub_insee_search
  end

  def stub_insee_token
    stub_request(:post, "https://api.insee.fr/token").to_return(
      status: 200,
      body: {"access_token" => "access_token_123"}.to_json,
      headers: {}
    )
  end

  def stub_insee_search
    stub_request(:get, "https://api.insee.fr/entreprises/sirene/V3.11/siret/13002526500013").to_return(
      status: 200,
      headers: {"Content-Type" => "application/json"},
      body: '{
        "header": {
          "statut": 200,
          "message": "ok"
        },
        "etablissement": {
          "siren": "130025265",
          "nic": "00013",
          "siret": "13002526500013",
          "statutDiffusionEtablissement": "O",
          "dateCreationEtablissement": "2017-05-24",
          "trancheEffectifsEtablissement": "22",
          "anneeEffectifsEtablissement": "2021",
          "activitePrincipaleRegistreMetiersEtablissement": null,
          "dateDernierTraitementEtablissement": "2023-11-30T10:17:12",
          "etablissementSiege": true,
          "nombrePeriodesEtablissement": 1,
          "uniteLegale": {
            "etatAdministratifUniteLegale": "A",
            "statutDiffusionUniteLegale": "O",
            "dateCreationUniteLegale": "2017-05-24",
            "categorieJuridiqueUniteLegale": "7120",
            "denominationUniteLegale": "DIRECTION INTERMINISTERIELLE DU NUMERIQUE",
            "sigleUniteLegale": "DINUM",
            "denominationUsuelle1UniteLegale": null,
            "denominationUsuelle2UniteLegale": null,
            "denominationUsuelle3UniteLegale": null,
            "sexeUniteLegale": null,
            "nomUniteLegale": null,
            "nomUsageUniteLegale": null,
            "prenom1UniteLegale": null,
            "prenom2UniteLegale": null,
            "prenom3UniteLegale": null,
            "prenom4UniteLegale": null,
            "prenomUsuelUniteLegale": null,
            "pseudonymeUniteLegale": null,
            "activitePrincipaleUniteLegale": "84.11Z",
            "nomenclatureActivitePrincipaleUniteLegale": "NAFRev2",
            "identifiantAssociationUniteLegale": null,
            "economieSocialeSolidaireUniteLegale": "N",
            "societeMissionUniteLegale": null,
            "caractereEmployeurUniteLegale": "N",
            "trancheEffectifsUniteLegale": "22",
            "anneeEffectifsUniteLegale": "2021",
            "nicSiegeUniteLegale": "00013",
            "dateDernierTraitementUniteLegale": "2023-11-30T10:17:13",
            "categorieEntreprise": "PME",
            "anneeCategorieEntreprise": "2021"
          },
          "adresseEtablissement": {
            "complementAdresseEtablissement": null,
            "numeroVoieEtablissement": "20",
            "indiceRepetitionEtablissement": null,
            "typeVoieEtablissement": "AV",
            "libelleVoieEtablissement": "DE SEGUR",
            "codePostalEtablissement": "75007",
            "libelleCommuneEtablissement": "PARIS 7",
            "libelleCommuneEtrangerEtablissement": null,
            "distributionSpecialeEtablissement": null,
            "codeCommuneEtablissement": "75107",
            "codeCedexEtablissement": null,
            "libelleCedexEtablissement": null,
            "codePaysEtrangerEtablissement": null,
            "libellePaysEtrangerEtablissement": null
          },
          "adresse2Etablissement": {
            "complementAdresse2Etablissement": null,
            "numeroVoie2Etablissement": null,
            "indiceRepetition2Etablissement": null,
            "typeVoie2Etablissement": null,
            "libelleVoie2Etablissement": null,
            "codePostal2Etablissement": null,
            "libelleCommune2Etablissement": null,
            "libelleCommuneEtranger2Etablissement": null,
            "distributionSpeciale2Etablissement": null,
            "codeCommune2Etablissement": null,
            "codeCedex2Etablissement": null,
            "libelleCedex2Etablissement": null,
            "codePaysEtranger2Etablissement": null,
            "libellePaysEtranger2Etablissement": null
          },
          "periodesEtablissement": [
            {
              "dateFin": null,
              "dateDebut": "2017-05-24",
              "etatAdministratifEtablissement": "A",
              "changementEtatAdministratifEtablissement": false,
              "enseigne1Etablissement": null,
              "enseigne2Etablissement": null,
              "enseigne3Etablissement": null,
              "changementEnseigneEtablissement": false,
              "denominationUsuelleEtablissement": null,
              "changementDenominationUsuelleEtablissement": false,
              "activitePrincipaleEtablissement": "84.11Z",
              "nomenclatureActivitePrincipaleEtablissement": "NAFRev2",
              "changementActivitePrincipaleEtablissement": false,
              "caractereEmployeurEtablissement": "N",
              "changementCaractereEmployeurEtablissement": false
            }
          ]
        }
      }'
    )
  end
end

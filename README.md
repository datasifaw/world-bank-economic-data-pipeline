# World Bank Economic Data Pipeline

**Projet Data Engineering de bout en bout | Qlik Talend Cloud · API REST · Google BigQuery · SQL · Looker Studio**

![Statut](https://img.shields.io/badge/Statut-En%20préparation-blue)
![Data Engineering](https://img.shields.io/badge/Domaine-Data%20Engineering-0A66C2)
![ETL](https://img.shields.io/badge/ETL-Qlik%20Talend%20Cloud-orange)
![Source](https://img.shields.io/badge/Source-World%20Bank%20API-00897B)

## 1. Présentation du projet

Ce projet a pour objectif de concevoir et de développer un **pipeline ETL (Extract, Transform, Load) de bout en bout**, entièrement basé sur des services Cloud.

Il consiste à extraire des indicateurs économiques depuis l'API REST de la Banque mondiale (World Bank), à les transformer avec Qlik Talend Cloud, puis à les charger dans Google BigQuery afin de réaliser des analyses SQL et des visualisations avec Looker Studio.

Le projet vise à démontrer plusieurs compétences essentielles en Data Engineering :

- Consommation et intégration d'API REST
- Extraction et traitement de données JSON
- Développement de pipelines ETL
- Nettoyage et transformation de données
- Contrôles de qualité des données (Data Quality)
- Chargement dans un Data Warehouse Cloud
- Analyse de données avec SQL
- Création de tableaux de bord décisionnels
- Documentation technique et versionnement avec GitHub

**Statut actuel :** phase de préparation et de conception. Le développement et les tests restent à réaliser.

## 2. Contexte et problématique métier

Les données économiques internationales sont disponibles à travers différentes sources, indicateurs et périodes.

Leur exploitation nécessite des traitements pour harmoniser les formats, gérer les valeurs manquantes et faciliter les comparaisons entre pays.

**Problématique :**

Comment le PIB, l'inflation, le chômage et la population ont-ils évolué dans six grandes économies mondiales entre 2015 et 2024 ?

Le projet permettra de construire un jeu de données analytique centralisé afin de comparer les performances économiques des pays sélectionnés.

## 3. Périmètre du projet

### Pays étudiés

| Pays | Code ISO |
|---|---|
| France | FRA |
| Allemagne | DEU |
| États-Unis | USA |
| Chine | CHN |
| Japon | JPN |
| Inde | IND |

### Indicateurs économiques

| Indicateur | Code API World Bank | Unité |
|---|---|---|
| Produit intérieur brut (PIB) | `NY.GDP.MKTP.CD` | Dollars US courants |
| Inflation annuelle | `FP.CPI.TOTL.ZG` | Pourcentage annuel |
| Taux de chômage | `SL.UEM.TOTL.ZS` | Pourcentage de la population active |
| Population totale | `SP.POP.TOTL` | Nombre d'habitants |

**Période d'analyse :** 2015 à 2024.

**Volume théorique :** 6 pays × 4 indicateurs × 10 années = 240 observations potentielles.

Le volume réellement exploitable dépendra de la disponibilité des données et des valeurs manquantes dans l'API.

## 4. Technologies utilisées

| Technologie | Rôle dans le projet |
|---|---|
| World Bank REST API | Source des données économiques |
| Qlik Talend Cloud | Développement et exécution des pipelines ETL |
| Talend HTTP Client | Extraction des données via HTTPS |
| Talend Pipeline Designer | Transformation et traitement des données |
| Google BigQuery | Stockage analytique dans le Cloud |
| SQL | Analyse et contrôles de qualité |
| Looker Studio | Visualisation et tableaux de bord |
| GitHub | Documentation et versionnement |

L'objectif est de travailler **100 % en ligne**, sans installation de Talend Studio ni de SQL Server local.

La disponibilité des connecteurs et des fonctionnalités nécessaires devra être validée dans les environnements d'essai.

## 5. Architecture du projet

Le flux de données prévu est le suivant :

```text
+---------------------------+
|    WORLD BANK REST API    |
|     Données JSON / HTTP   |
+-------------+-------------+
              |
              v
+---------------------------+
|      QLIK TALEND CLOUD    |
|                           |
|  - Extraction API         |
|  - Parsing JSON           |
|  - Nettoyage              |
|  - Transformation         |
|  - Contrôles qualité      |
+-------------+-------------+
              |
              v
+---------------------------+
|       GOOGLE BIGQUERY     |
|                           |
|  BRONZE : Données brutes  |
|  SILVER : Données propres |
|  GOLD   : Données métier  |
+-------------+-------------+
              |
              v
+---------------------------+
|       LOOKER STUDIO       |
|                           |
|  - Tableaux de bord       |
|  - Indicateurs KPI        |
|  - Analyses économiques   |
+---------------------------+
```

### Architecture Medallion

Le projet adoptera une architecture en trois couches.

**Bronze — Données brutes**

Cette couche contiendra les données issues de l'API World Bank, ainsi que les informations nécessaires à leur traçabilité : source, date d'extraction et identifiant de chargement.

**Silver — Données nettoyées**

Cette couche contiendra les données transformées, normalisées, typées et contrôlées.

Les principaux traitements comprendront la gestion des valeurs manquantes, la conversion des types, la standardisation des codes pays et la suppression des doublons.

**Gold — Données analytiques**

Cette couche regroupera les indicateurs économiques par pays et par année pour faciliter les analyses SQL et les visualisations.

La structure physique définitive sera déterminée après validation des connexions Talend Cloud et BigQuery.

## 6. Extraction des données — World Bank API

L'extraction sera réalisée à partir de l'API officielle de la Banque mondiale.

**Documentation officielle :**

https://datahelpdesk.worldbank.org/knowledgebase/articles/889392

### Exemple de requête API

Extraction des données PIB des six pays entre 2015 et 2024 :

```text
https://api.worldbank.org/v2/country/FRA;DEU;USA;CHN;JPN;IND/indicator/NY.GDP.MKTP.CD?format=json&date=2015:2024&per_page=1000
```

L'API retourne une réponse JSON contenant des métadonnées de pagination et des observations économiques.

### Étapes d'ingestion prévues

1. Envoyer une requête HTTP GET à l'API World Bank.
2. Vérifier le statut HTTP et la structure de la réponse JSON.
3. Lire les métadonnées de pagination.
4. Extraire les informations utiles.
5. Conserver les métadonnées de traçabilité.
6. Normaliser les données dans un format tabulaire.
7. Transmettre les données aux étapes de transformation.

## 7. Transformations ETL

Les traitements prévus dans Talend Cloud comprennent :

- Extraction des champs JSON imbriqués
- Conversion des années en valeurs numériques
- Conversion des indicateurs en types numériques
- Harmonisation des codes pays
- Traitement des valeurs nulles
- Détection et suppression des doublons
- Jointure des indicateurs sur le pays et l'année
- Calcul d'indicateurs dérivés
- Préparation des données pour BigQuery

### Structure cible de la table Gold

**Table : `fact_economic_indicators`**

| Colonne | Type BigQuery | Description |
|---|---|---|
| country_code | STRING | Code ISO du pays |
| country_name | STRING | Nom du pays |
| year | INT64 | Année de référence |
| gdp_usd | FLOAT64 | PIB en dollars US courants |
| inflation_pct | FLOAT64 | Taux d'inflation annuel |
| unemployment_pct | FLOAT64 | Taux de chômage |
| population | INT64 | Population totale |
| gdp_per_capita | FLOAT64 | PIB par habitant |
| load_timestamp | TIMESTAMP | Date de chargement |

### Indicateur calculé : PIB par habitant

Le PIB par habitant sera calculé selon la formule suivante :

`PIB par habitant = PIB en USD / Population totale`

Si la population est nulle, égale à zéro ou indisponible, le résultat restera NULL afin d'éviter un calcul incorrect.

## 8. Contrôles qualité des données

La qualité des données est un élément essentiel du projet.

Les règles suivantes seront implémentées et documentées :

| Contrôle | Règle |
|---|---|
| Complétude des pays | Le code pays ne doit pas être NULL |
| Complétude des années | L'année ne doit pas être NULL |
| Validité des années | Année comprise entre 2015 et 2024 |
| Validité des pays | Pays appartenant au périmètre défini |
| Unicité des données sources | Une ligne par pays, année et indicateur |
| Unicité des données Gold | Une ligne par pays et année |
| Cohérence des types | Valeurs économiques correctement typées |
| Valeurs manquantes | Identification des valeurs NULL |
| Validité de la population | Population strictement positive lorsqu'elle est renseignée |
| Cohérence des volumes | Comparaison des enregistrements extraits, rejetés et chargés |

Les valeurs manquantes ne seront pas remplacées automatiquement par zéro.

**Résultats des contrôles :** non disponibles à ce stade. Ils seront renseignés après l'exécution du pipeline.

## 9. Stockage des données — Google BigQuery

Google BigQuery sera utilisé comme Data Warehouse cible, sous réserve de la validation des accès et de la connectivité.

### Datasets prévus

```text
world_bank_bronze
world_bank_silver
world_bank_gold
```

### Table analytique principale

`world_bank_gold.fact_economic_indicators`

### Exemple de requête SQL

Calcul de l'inflation et du chômage moyens par pays sur la période étudiée :

```sql
SELECT
    country_name,
    ROUND(AVG(inflation_pct), 2) AS avg_inflation_pct,
    ROUND(AVG(unemployment_pct), 2) AS avg_unemployment_pct
FROM
    `PROJECT_ID.world_bank_gold.fact_economic_indicators`
WHERE
    year BETWEEN 2015 AND 2024
GROUP BY
    country_name
ORDER BY
    avg_inflation_pct DESC;
```

`PROJECT_ID` devra être remplacé par l'identifiant réel du projet Google Cloud.

Cette requête constitue un exemple de traitement prévu. Elle n'a pas encore été exécutée sur des données chargées.

## 10. Visualisation — Looker Studio

Un tableau de bord interactif sera développé afin de présenter les indicateurs économiques.

### Analyses prévues

**Analyse du PIB**
- Évolution annuelle du PIB par pays
- Comparaison du PIB entre les six pays
- Évolution du PIB par habitant

**Analyse de l'inflation**
- Évolution des taux d'inflation
- Comparaison entre pays
- Analyse des variations annuelles

**Analyse du chômage**
- Évolution du taux de chômage
- Comparaison des taux moyens
- Analyse conjointe du chômage et de l'inflation

**Analyse démographique**
- Évolution de la population
- Comparaison entre pays

### Filtres interactifs

- Pays
- Année
- Indicateur économique

**Statut du dashboard :** à développer.

Le lien et les captures d'écran seront ajoutés après réalisation.

## 11. Structure du dépôt GitHub

```text
world-bank-economic-data-pipeline/
|
|-- README.md
|
|-- docs/
|   |-- architecture.md
|   |-- data_dictionary.md
|   |-- data_quality.md
|   |-- setup_guide.md
|
|-- pipelines/
|   |-- pipeline_documentation.md
|
|-- sql/
|   |-- create_tables.sql
|   |-- transformations.sql
|   |-- data_quality_checks.sql
|   |-- analytical_queries.sql
|
|-- data_samples/
|   |-- sample_response.json
|
|-- screenshots/
|   |-- README.md
|
|-- .gitignore
```

Cette organisation est prévisionnelle. Les fichiers seront ajoutés au fur et à mesure de l'avancement réel.

Les clés API, mots de passe, fichiers d'identifiants Google Cloud et autres informations sensibles ne seront pas publiés.

## 12. Planning du projet — 4 jours

### Jour 1 — Configuration et extraction

- [ ] Créer et configurer le compte Talend Cloud
- [ ] Vérifier l'accès à Pipeline Designer
- [ ] Vérifier la disponibilité du Cloud Engine
- [ ] Configurer HTTP Client
- [ ] Tester la connexion à l'API World Bank
- [ ] Parser la réponse JSON
- [ ] Vérifier la connexion à BigQuery

**Livrable attendu :** première extraction fonctionnelle depuis l'API World Bank.

### Jour 2 — Transformation et qualité

- [ ] Extraire les quatre indicateurs économiques
- [ ] Normaliser les structures JSON
- [ ] Convertir les types de données
- [ ] Traiter les valeurs manquantes
- [ ] Détecter les doublons
- [ ] Réaliser les jointures
- [ ] Implémenter les contrôles qualité

**Livrable attendu :** jeu de données propre et validé.

### Jour 3 — BigQuery et SQL

- [ ] Créer les datasets BigQuery
- [ ] Créer les tables nécessaires
- [ ] Charger les données nettoyées
- [ ] Construire la table Gold
- [ ] Calculer le PIB par habitant
- [ ] Écrire et tester les requêtes SQL
- [ ] Vérifier les volumes de données
- [ ] Tester la relance du pipeline sans doublons inattendus

**Livrable attendu :** Data Warehouse interrogeable avec SQL.

### Jour 4 — Dashboard et GitHub

- [ ] Construire le dashboard Looker Studio
- [ ] Ajouter les indicateurs et filtres
- [ ] Comparer les résultats du dashboard avec SQL
- [ ] Capturer les pipelines Talend Cloud
- [ ] Documenter les difficultés rencontrées
- [ ] Finaliser le README
- [ ] Publier les livrables sur GitHub

**Livrable attendu :** projet Data Engineering documenté et présentable en entretien.

Ce planning constitue un objectif. Il dépend notamment des fonctionnalités accessibles dans les environnements d'essai.

## 13. État d'avancement et résultats

### État actuel

**Phase : préparation du projet**

| Composant | État |
|---|---|
| Définition du besoin métier | Défini |
| Sélection des pays | Défini |
| Sélection des indicateurs | Défini |
| Architecture technique | Proposée |
| Extraction API World Bank | Non commencée |
| Développement ETL Talend | Non commencé |
| Contrôles qualité | Non commencés |
| Chargement BigQuery | Non commencé |
| Analyses SQL | Non commencées |
| Dashboard Looker Studio | Non commencé |
| Tests de bout en bout | Non commencés |

### Résultats attendus

- Pipeline d'extraction REST opérationnel
- Données économiques transformées et standardisées
- Contrôles qualité documentés
- Data Warehouse interrogeable
- Analyses SQL des indicateurs économiques
- Dashboard interactif
- Documentation technique sur GitHub

### Résultats réellement obtenus

À ce stade, aucune extraction, transformation, exécution Talend, insertion BigQuery ou validation de dashboard n'a encore été réalisée.

Cette section sera mise à jour au cours du projet avec les volumes réellement chargés, les résultats des tests, les éventuelles anomalies et les captures d'écran.

## 14. Difficultés techniques et solutions

Les difficultés potentielles identifiées sont :

- Parsing des réponses JSON de l'API World Bank
- Gestion de la pagination et des valeurs manquantes
- Harmonisation des indicateurs économiques
- Jointures entre jeux de données
- Configuration de la connexion Talend–BigQuery
- Prévention des doublons lors des chargements répétés
- Contraintes des périodes d'essai Cloud

Les difficultés effectivement rencontrées, les solutions adoptées et les décisions techniques seront documentées pendant la réalisation.

## 15. Améliorations futures

Les évolutions possibles après la première version sont :

- Paramétrage dynamique des pays et des périodes
- Ingestion incrémentale
- Planification automatique des pipelines
- Monitoring et gestion des erreurs
- Alertes en cas d'échec
- Ajout d'autres indicateurs économiques
- Développement d'un modèle dimensionnel
- Automatisation des tests qualité

Ces améliorations ne font pas partie du périmètre obligatoire des quatre premiers jours.

## 16. Sources et documentation

**Banque mondiale — Open Data**

https://data.worldbank.org/

**Documentation API World Bank**

https://datahelpdesk.worldbank.org/knowledgebase/articles/889392

**Documentation Qlik Talend**

https://help.qlik.com/

**Documentation Google BigQuery**

https://cloud.google.com/bigquery/docs

**Google Looker Studio**

https://lookerstudio.google.com/

Les données économiques proviennent de la Banque mondiale. Les définitions, les sources et les conditions de réutilisation des indicateurs devront être respectées.

## 17. Objectif professionnel

Ce projet est réalisé dans le cadre d'un **portfolio Data Engineering**.

Il vise à démontrer la capacité à concevoir et à mettre en œuvre une chaîne complète d'intégration de données économiques : ingestion depuis une API REST, transformations ETL, contrôles de qualité, stockage analytique, analyses SQL et visualisation.

L'objectif final est de disposer d'un projet Cloud reproductible, documenté et présentable lors d'un entretien technique pour un poste de Data Engineer.

---

**Projet :** World Bank Economic Data Pipeline  
**Domaine :** Data Engineering / ETL / Cloud Analytics  
**Statut :** En préparation — Développement à venir

# 🌍 World Bank Economic Data Pipeline

### Projet Data Engineering de bout en bout — API REST · Talend Studio 8 · SQL Server · Power BI

![Statut](https://img.shields.io/badge/Statut-En%20cours-yellow)
![Talend](https://img.shields.io/badge/ETL-Talend%20Studio%208-orange)
![SQL Server](https://img.shields.io/badge/Database-Microsoft%20SQL%20Server-blue)
![Power BI](https://img.shields.io/badge/BI-Power%20BI-yellow)
![World Bank](https://img.shields.io/badge/API-World%20Bank-green)

## 1. Présentation du projet

Ce projet consiste à concevoir et développer un **pipeline ETL (Extract, Transform, Load) de bout en bout** permettant d'extraire, transformer, contrôler et analyser des indicateurs économiques provenant de l'API REST de la Banque mondiale (World Bank).

Les données seront récupérées au format JSON, transformées avec **Talend Studio 8**, puis chargées dans une base **Microsoft SQL Server**.

Les données consolidées serviront ensuite à construire un tableau de bord interactif avec **Microsoft Power BI**.

Ce projet est développé dans le cadre d'un **portfolio Data Engineering** afin de démontrer des compétences techniques en ingestion de données, développement ETL, qualité des données, modélisation SQL et Business Intelligence.

### Objectifs techniques

- Consommer une API REST publique.
- Extraire et parser des données JSON.
- Concevoir des Jobs ETL avec Talend Studio 8.
- Nettoyer, transformer et normaliser les données économiques.
- Implémenter des contrôles qualité.
- Charger les données dans SQL Server.
- Structurer les données selon une architecture Bronze, Silver et Gold.
- Exécuter des requêtes SQL analytiques.
- Concevoir un tableau de bord Power BI.
- Versionner les Jobs Talend avec Git et documenter le projet sur GitHub.

**Statut actuel :** environnement Talend Studio 8 configuré, licence activée et projet distant reconnu. Développement ETL à commencer.

---

## 2. Contexte et problématique métier

La Banque mondiale met à disposition de nombreux indicateurs économiques concernant les pays du monde.

Ces données sont accessibles via une API REST, mais leur exploitation nécessite plusieurs traitements :

- Extraction des données depuis différentes requêtes API.
- Harmonisation des structures JSON.
- Gestion des valeurs nulles.
- Standardisation des codes pays et des années.
- Consolidation de plusieurs indicateurs.
- Vérification de la cohérence des données.

### Problématique métier

**Comment le PIB, l'inflation, le chômage et la population ont-ils évolué dans six grandes économies mondiales entre 2015 et 2024 ?**

Le projet vise à créer un système d'intégration et d'analyse permettant de comparer ces indicateurs dans le temps et entre les pays.

### Questions analytiques

1. Comment le PIB a-t-il évolué entre 2015 et 2024 ?
2. Quels pays affichent les taux d'inflation les plus élevés ?
3. Comment le chômage a-t-il évolué selon les pays ?
4. Quelle est l'évolution du PIB par habitant ?
5. Quelles différences économiques observe-t-on entre les pays étudiés ?

---

## 3. Périmètre des données

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

| Indicateur | Code World Bank | Unité |
|---|---|---|
| Produit intérieur brut | `NY.GDP.MKTP.CD` | Dollars US courants |
| Inflation annuelle | `FP.CPI.TOTL.ZG` | Pourcentage annuel |
| Taux de chômage | `SL.UEM.TOTL.ZS` | Pourcentage de la population active |
| Population totale | `SP.POP.TOTL` | Nombre d'habitants |

**Période d'analyse : 2015–2024**

### Volume théorique

- 6 pays
- 4 indicateurs
- 10 années

Soit **240 observations potentielles** avant prise en compte des données manquantes.

Le jeu analytique consolidé contiendra jusqu'à **60 combinaisons pays-année**.

Les volumes définitifs seront mesurés après extraction et validation des données.

---

## 4. Technologies utilisées

| Technologie | Rôle |
|---|---|
| World Bank REST API | Source des données économiques |
| Talend Studio 8 | Développement des Jobs ETL |
| Qlik Talend Cloud | Gestion des projets, licence et collaboration |
| Microsoft SQL Server | Stockage des données |
| SQL Server Management Studio 22 | Administration et requêtes SQL |
| Microsoft Power BI | Reporting et visualisation |
| Git / GitHub | Versionnement du projet |
| Java JDK | Environnement nécessaire à Talend Studio |

### Environnement de développement

- Système d'exploitation : Windows
- ETL : Talend Studio 8
- Licence : Qlik Talend Cloud Enterprise Edition — essai gratuit
- Région Cloud : France
- Projet Talend : `World_Bank_Economic_Data_Pipeline`
- Branche Git : `main`

**Note :** la licence Talend Studio utilisée est temporaire. La reproductibilité future du projet dépendra de la disponibilité d'une licence compatible.

---

## 5. Architecture technique

L'architecture cible est la suivante :

```text
+--------------------------------------+
|          WORLD BANK REST API         |
|                                      |
|  GDP | Inflation | Unemployment      |
|             Population               |
+------------------+-------------------+
                   |
                   | HTTPS / JSON
                   v
+--------------------------------------+
|             TALEND STUDIO 8          |
|                                      |
|  1. Extraction API REST              |
|  2. Parsing JSON                     |
|  3. Nettoyage des données            |
|  4. Transformation                   |
|  5. Contrôles qualité                |
|  6. Chargement des données           |
+------------------+-------------------+
                   |
                   | JDBC
                   v
+--------------------------------------+
|         MICROSOFT SQL SERVER         |
|                                      |
|  BRONZE : Données brutes             |
|  SILVER : Données nettoyées          |
|  GOLD   : Données analytiques        |
+------------------+-------------------+
                   |
                   | SQL
                   v
+--------------------------------------+
|             MICROSOFT POWER BI       |
|                                      |
|  KPI | Graphiques | Comparaisons     |
|             Tableau de bord          |
+--------------------------------------+
```

**Statut de l'architecture :** proposée, pas encore exécutée de bout en bout.

---

## 6. Organisation des données : Bronze, Silver et Gold

Le projet utilisera une architecture en trois niveaux afin de séparer les données sources, les données nettoyées et les données destinées aux analyses.

### Bronze — Données brutes

Cette couche conservera les données récupérées depuis l'API World Bank.

Informations prévues :

- Pays
- Code de l'indicateur
- Année
- Valeur économique
- Source de données
- Date et heure d'extraction
- Identifiant du lot d'ingestion

Objectif : préserver la traçabilité des données sources.

### Silver — Données nettoyées

Cette couche contiendra les données standardisées.

Transformations prévues :

- Extraction des champs JSON utiles
- Standardisation des codes pays
- Conversion des types numériques
- Contrôle des années
- Détection des doublons
- Gestion des valeurs manquantes
- Contrôle des valeurs incohérentes

Objectif : fournir des données fiables pour les traitements analytiques.

### Gold — Données analytiques

Cette couche contiendra les données consolidées et structurées pour les requêtes SQL et Power BI.

Traitements prévus :

- Jointures entre les indicateurs
- Consolidation par pays et année
- Calcul du PIB par habitant
- Préparation des indicateurs KPI
- Optimisation des données pour le reporting

---

## 7. Source de données : API REST World Bank

La source officielle utilisée est la **World Bank Indicators API V2**.

Documentation :

https://datahelpdesk.worldbank.org/knowledgebase/articles/889392

### Requête API — PIB

```text
https://api.worldbank.org/v2/country/FRA;DEU;USA;CHN;JPN;IND/indicator/NY.GDP.MKTP.CD?format=json&date=2015:2024&per_page=1000
```

### Requête API — Inflation

```text
https://api.worldbank.org/v2/country/FRA;DEU;USA;CHN;JPN;IND/indicator/FP.CPI.TOTL.ZG?format=json&date=2015:2024&per_page=1000
```

### Requête API — Chômage

```text
https://api.worldbank.org/v2/country/FRA;DEU;USA;CHN;JPN;IND/indicator/SL.UEM.TOTL.ZS?format=json&date=2015:2024&per_page=1000
```

### Requête API — Population

```text
https://api.worldbank.org/v2/country/FRA;DEU;USA;CHN;JPN;IND/indicator/SP.POP.TOTL?format=json&date=2015:2024&per_page=1000
```

Les requêtes utilisent le protocole HTTPS et renvoient des données au format JSON.

L'API fournit également des métadonnées de pagination qui seront prises en compte dans les contrôles d'extraction.

---

## 8. Développement des Jobs Talend Studio 8

Le développement sera organisé en plusieurs Jobs ETL.

### Job 01 — Extraction des données PIB

**Nom prévu :** `JOB_01_WorldBank_GDP_Extraction`

Objectif :

- Envoyer une requête HTTP à l'API World Bank.
- Vérifier la réponse HTTP.
- Récupérer les observations PIB.
- Parser la réponse JSON.
- Convertir les données au format tabulaire.
- Afficher et contrôler les premières lignes.

Composants Talend envisagés :

- `tRESTClient` ou `tHttpRequest`, selon disponibilité
- `tExtractJSONFields`
- `tMap`
- `tLogRow`

### Job 02 — Extraction des autres indicateurs

**Nom prévu :** `JOB_02_WorldBank_Indicators_Extraction`

Objectif :

- Extraire les données d'inflation.
- Extraire les taux de chômage.
- Extraire les populations.
- Normaliser les structures.
- Préparer les données pour leur intégration.

### Job 03 — Nettoyage et transformation

**Nom prévu :** `JOB_03_Economic_Data_Transformation`

Objectif :

- Convertir les types.
- Contrôler les valeurs nulles.
- Standardiser les données.
- Identifier les doublons.
- Effectuer les jointures.
- Calculer les métriques dérivées.

Composants envisagés :

- `tMap`
- `tFilterRow`
- `tUniqRow`
- `tLogRow`

### Job 04 — Chargement SQL Server

**Nom prévu :** `JOB_04_SQLServer_Data_Load`

Objectif :

- Établir la connexion SQL Server.
- Charger les tables Bronze et Silver.
- Construire la table Gold.
- Contrôler les volumes insérés.
- Gérer les erreurs de chargement.

Composants envisagés :

- `tMSSqlConnection`
- `tMSSqlInput`
- `tMSSqlOutput`
- `tMSSqlCommit`

Les composants définitifs seront confirmés pendant le développement dans Talend Studio 8.

---

## 9. Base de données Microsoft SQL Server

SQL Server sera utilisé comme base de données cible.

### Base prévue

`WorldBank_Economic_DB`

### Schémas SQL prévus

```text
WorldBank_Economic_DB
|
|-- bronze
|    |-- raw_economic_indicators
|
|-- silver
|    |-- clean_economic_indicators
|
|-- gold
     |-- fact_economic_indicators
```

### Structure analytique Gold

| Colonne | Type SQL Server | Description |
|---|---|---|
| country_code | VARCHAR(3) | Code ISO du pays |
| country_name | NVARCHAR(100) | Nom du pays |
| year | INT | Année de référence |
| gdp_usd | DECIMAL(28,2) | PIB en USD |
| inflation_pct | FLOAT | Taux d'inflation |
| unemployment_pct | FLOAT | Taux de chômage |
| population | BIGINT | Population totale |
| gdp_per_capita | DECIMAL(20,2) | PIB par habitant |
| load_timestamp | DATETIME2 | Date de chargement |

Clé métier prévue : `(country_code, year)`.

### Exemple de requête SQL

Analyse du PIB et du PIB par habitant :

```sql
SELECT
    country_name,
    year,
    gdp_usd,
    population,
    gdp_per_capita
FROM gold.fact_economic_indicators
WHERE year BETWEEN 2015 AND 2024
ORDER BY country_name, year;
```

Cette requête représente une analyse prévue. Elle n'a pas encore été exécutée sur la base du projet.

---

## 10. Contrôles qualité des données

Des règles de validation seront mises en place à chaque étape du pipeline.

| Contrôle | Règle |
|---|---|
| Complétude | Le pays et l'année ne doivent pas être NULL |
| Validité des années | Année comprise entre 2015 et 2024 |
| Validité des codes pays | Code appartenant aux six pays étudiés |
| Unicité source | Une ligne par pays, année et indicateur |
| Unicité Gold | Une ligne par pays et année |
| Cohérence des types | Indicateurs correctement typés |
| Valeurs manquantes | Identification et suivi des NULL |
| Population | Valeur strictement positive lorsqu'elle est renseignée |
| Chargement | Contrôle des volumes extraits, rejetés et chargés |

Les valeurs économiques manquantes ne seront pas remplacées automatiquement par zéro.

### Résultats qualité

**À compléter après l'exécution des Jobs Talend.**

Les indicateurs suivants seront suivis :

- Nombre de lignes extraites
- Nombre de lignes valides
- Nombre de lignes rejetées
- Nombre de doublons
- Nombre de valeurs manquantes
- Nombre de lignes chargées dans SQL Server

---

## 11. Dashboard Microsoft Power BI

Le tableau de bord Power BI permettra d'explorer les données économiques des six pays.

### Indicateurs KPI prévus

- PIB total par pays
- PIB par habitant
- Inflation moyenne
- Taux de chômage moyen
- Évolution de la population

### Visualisations prévues

**Analyse du PIB**
- Évolution annuelle du PIB
- Comparaison entre pays
- PIB par habitant

**Analyse de l'inflation**
- Évolution annuelle
- Comparaison des taux d'inflation
- Analyse des variations

**Analyse du chômage**
- Évolution des taux
- Comparaisons internationales
- Tendances historiques

**Analyse démographique**
- Population par pays
- Évolution annuelle
- Comparaison des populations

### Filtres

- Pays
- Année
- Indicateur économique

**Statut :** dashboard non encore développé.

---

## 12. Organisation GitHub

Le projet est organisé en deux dépôts complémentaires.

### Dépôt principal — Portfolio

**[world-bank-economic-data-pipeline](https://github.com/datasifaw/world-bank-economic-data-pipeline)**

Ce dépôt est consacré à la présentation du projet.

Il contiendra le README, la documentation technique, les scripts SQL, les captures d'écran, les contrôles qualité et les résultats.

### Dépôt technique — Talend Studio

**[world-bank-talend-studio](https://github.com/datasifaw/world-bank-talend-studio)**

Ce dépôt est lié au projet distant Talend Studio 8.

Il est destiné au versionnement des Jobs ETL et des fichiers techniques générés par Talend Studio.

**Branche utilisée :** `main`.

### Organisation prévue du dépôt principal

```text
world-bank-economic-data-pipeline/
|
|-- README.md
|
|-- docs/
|   |-- architecture.md
|   |-- data_dictionary.md
|   |-- data_quality.md
|   |-- installation_talend.md
|
|-- sql/
|   |-- create_database.sql
|   |-- create_tables.sql
|   |-- transformations.sql
|   |-- data_quality_checks.sql
|   |-- analytical_queries.sql
|
|-- data_samples/
|   |-- sample_worldbank_response.json
|
|-- screenshots/
|   |-- talend_jobs/
|   |-- sql_server/
|   |-- power_bi/
|
|-- .gitignore
```

Les fichiers seront ajoutés progressivement lors du développement.

Aucun mot de passe, jeton d'accès Talend, identifiant sensible ou secret de connexion SQL Server ne sera publié.

---

## 13. État d'avancement réel

### Configuration initiale

- [x] Création du compte Qlik Talend Cloud
- [x] Activation de l'essai Talend Cloud Enterprise Edition
- [x] Téléchargement de Talend Studio 8
- [x] Installation et configuration de Java
- [x] Premier démarrage de Talend Studio
- [x] Activation de la licence Talend Studio
- [x] Connexion à Talend Cloud France
- [x] Création du dépôt GitHub principal
- [x] Création du dépôt GitHub technique
- [x] Création du projet dans Talend Management Console
- [x] Attribution du collaborateur au projet
- [x] Reconnaissance du projet dans Talend Studio
- [x] Sélection de la branche Git `main`
- [ ] Ouverture complète de l'éditeur de projet Talend

### Développement ETL

- [ ] Création du premier Job Talend
- [ ] Connexion à l'API World Bank
- [ ] Extraction des données PIB
- [ ] Extraction des quatre indicateurs
- [ ] Parsing JSON
- [ ] Transformations et nettoyage
- [ ] Contrôles qualité
- [ ] Connexion à Microsoft SQL Server
- [ ] Chargement Bronze
- [ ] Chargement Silver
- [ ] Chargement Gold
- [ ] Tests de bout en bout

### Reporting et documentation

- [ ] Développement du dashboard Power BI
- [ ] Validation des indicateurs KPI
- [ ] Captures d'écran des Jobs Talend
- [ ] Documentation des erreurs et solutions
- [ ] Ajout des résultats réels
- [ ] Finalisation du portfolio GitHub

---

## 14. Plan de développement — 4 jours

Le projet était initialement prévu sur quatre jours. Une partie du temps a été consacrée à la configuration de Talend Studio et de son intégration Cloud/Git.

Le planning ci-dessous constitue donc une **feuille de route cible pour les quatre journées de développement**, et non une affirmation que ces travaux ont déjà été réalisés.

### Jour 1 — Extraction API

- Créer le premier Job Talend.
- Configurer l'appel à l'API World Bank.
- Parser les données JSON.
- Tester l'extraction du PIB.
- Contrôler les premiers résultats.

**Livrable attendu :** premier Job d'extraction fonctionnel.

### Jour 2 — Transformations ETL

- Extraire les quatre indicateurs.
- Normaliser les structures.
- Nettoyer les données.
- Implémenter les règles qualité.
- Préparer les tables Bronze et Silver.

**Livrable attendu :** données économiques standardisées.

### Jour 3 — SQL Server

- Configurer la connexion SQL Server.
- Créer la base et les schémas.
- Charger les données.
- Construire la table Gold.
- Écrire les requêtes SQL.
- Vérifier l'intégrité et les volumes.

**Livrable attendu :** base de données analytique fonctionnelle.

### Jour 4 — Power BI et GitHub

- Créer le tableau de bord Power BI.
- Développer les graphiques et filtres.
- Valider les résultats des KPI.
- Documenter les Jobs Talend.
- Ajouter les captures d'écran.
- Finaliser les dépôts GitHub.

**Livrable attendu :** projet documenté et démontrable pour un portfolio Data Engineer.

---

## 15. Difficultés techniques rencontrées

### Configuration initiale de Talend Studio 8

**Problème :** Talend Studio ne démarrait pas en raison de l'absence d'un environnement Java reconnu.

**Solution appliquée :** installation et configuration d'un JDK compatible, permettant le démarrage de Talend Studio 8.

### Authentification à Talend Cloud

**Problème :** la connexion initiale depuis Studio affichait une erreur d'authentification.

**Solution appliquée :** utilisation de la récupération de licence avec un jeton d'accès personnel et configuration du service Talend Cloud adapté à la région française.

### Accès au projet distant

**Problème :** Talend Studio affichait le message « Impossible de récupérer un projet depuis le Cloud », malgré la création du projet dans Management Console.

**Solution appliquée :** ajout explicite du compte utilisateur dans les collaborateurs du projet.

**Résultat observé :** le projet `World_Bank_Economic_Data_Pipeline` est désormais visible dans Talend Studio et la branche `main` peut être sélectionnée.

### Prochaines difficultés à documenter

- Extraction et parsing des réponses JSON
- Gestion des modules Talend
- Connexion à SQL Server
- Gestion des valeurs manquantes
- Chargement des données
- Validation des résultats analytiques

Les solutions correspondantes seront renseignées uniquement après leur mise en œuvre.

---

## 16. Résultats du projet

### Résultats déjà obtenus

- Installation fonctionnelle de Talend Studio 8 sur Windows.
- Activation de la licence d'essai.
- Connexion à Talend Cloud France.
- Création du projet Studio distant.
- Association du dépôt technique GitHub.
- Attribution des accès au projet.
- Projet visible dans Talend Studio avec la branche `main`.

### Résultats attendus

- Pipeline d'extraction World Bank fonctionnel.
- Données économiques nettoyées et standardisées.
- Chargement des tables SQL Server.
- Contrôles qualité documentés.
- Analyses SQL opérationnelles.
- Dashboard Power BI interactif.
- Documentation technique complète.

**Aucun résultat ETL, volume de données chargé ou indicateur analytique n'est encore annoncé comme réalisé.**

---

## 17. Améliorations futures

Après la première version, les améliorations envisagées comprennent :

- Paramétrage dynamique des pays et années
- Extraction incrémentale
- Planification automatique des Jobs
- Gestion des reprises après erreur
- Monitoring des traitements
- Automatisation des contrôles qualité
- Optimisation du modèle analytique
- Ajout d'autres indicateurs économiques

Ces évolutions ne sont pas incluses dans le périmètre initial.

---

## 18. Documentation et références

**World Bank Open Data**

https://data.worldbank.org/

**World Bank Indicators API**

https://datahelpdesk.worldbank.org/knowledgebase/articles/889392

**Qlik Talend Documentation**

https://help.qlik.com/

**Microsoft SQL Server Documentation**

https://learn.microsoft.com/sql/

**Microsoft Power BI Documentation**

https://learn.microsoft.com/power-bi/

**Dépôt technique Talend**

https://github.com/datasifaw/world-bank-talend-studio

Les données économiques proviennent de la Banque mondiale. Les définitions des indicateurs, leurs sources et leurs conditions de réutilisation seront respectées.

---

## 19. Objectif professionnel

Ce projet est réalisé dans le cadre d'un **portfolio Data Engineering**, avec pour objectif de démontrer une maîtrise pratique des étapes de conception et de développement d'un pipeline de données.

Il couvre notamment :

- L'intégration de données depuis une API REST
- La construction de traitements ETL dans Talend Studio
- La transformation et la qualité des données
- L'intégration avec Microsoft SQL Server
- L'analyse de données avec SQL
- La visualisation avec Power BI
- Le versionnement avec GitHub
- La résolution de problèmes techniques réels

Le projet sera progressivement enrichi avec les fichiers techniques, captures d'écran et résultats vérifiés.

---

**Projet :** World Bank Economic Data Pipeline  
**Domaine :** Data Engineering / ETL / Data Quality / Business Intelligence  
**Outils :** Talend Studio 8 · World Bank API · SQL Server · Power BI · GitHub  
**Statut :** En cours de développement — Environnement configuré, ingestion ETL à commencer.

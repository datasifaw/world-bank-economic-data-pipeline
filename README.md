# 🌍 World Bank Economic Data Pipeline :

**Projet Data Engineering de bout en bout — World Bank REST API · Qlik Talend Studio 8 · Microsoft SQL Server · Power BI**

![Statut](https://img.shields.io/badge/Statut-Version%20fonctionnelle-success)
![ETL](https://img.shields.io/badge/ETL-Qlik%20Talend%20Studio%208-orange)
![SQL Server](https://img.shields.io/badge/Stockage-SQL%20Server-blue)
![Power BI](https://img.shields.io/badge/BI-Power%20BI-yellow)
![Source](https://img.shields.io/badge/Source-World%20Bank-green)

## 1. Présentation

Ce projet de portfolio illustre la conception et la réalisation d'un pipeline de données économiques **de l'extraction à la visualisation**. Les données proviennent de l'API REST publique de la Banque mondiale, sont extraites et transformées dans **Qlik Talend Studio 8**, chargées dans **Microsoft SQL Server**, puis analysées avec **Power BI Desktop**.

Le pipeline traite quatre indicateurs pour six pays. Les exécutions vérifiées ont produit **264 observations** dans la couche Silver, couvrant **2015 à 2025**. Une valeur manquante est conservée comme `NULL` plutôt que remplacée artificiellement par zéro.

> **Périmètre réellement livré :** extraction Talend, chargements Bronze, transformations SQL vers Silver, contrôles qualité et tableau de bord Power BI. La couche Gold, l'orchestration automatique et le chargement Bronze idempotent font partie des améliorations futures.

## 2. Problématique et objectifs

**Comment comparer l'évolution du PIB, de l'inflation, du chômage et de la population dans six grandes économies entre 2015 et 2025 ?**

Le projet vise à :

- Collecter des données via une API REST au format JSON.
- Transformer des réponses JSON en données tabulaires avec Talend Studio.
- Stocker les observations dans SQL Server en séparant **Bronze** et **Silver**.
- Vérifier la couverture, l'unicité, les valeurs manquantes et la cohérence des données.
- Construire des visualisations interactives avec Power BI.
- Versionner les scripts et les Jobs sur GitHub.

## 3. Périmètre des données

### Pays

| Pays | Code ISO 3 |
|---|---|
| France | `FRA` |
| Allemagne | `DEU` |
| États-Unis | `USA` |
| Chine | `CHN` |
| Japon | `JPN` |
| Inde | `IND` |

### Indicateurs

| Indicateur | Code World Bank | Unité |
|---|---|---|
| Produit intérieur brut | `NY.GDP.MKTP.CD` | USD courants |
| Inflation annuelle | `FP.CPI.TOTL.ZG` | % annuel |
| Taux de chômage | `SL.UEM.TOTL.ZS` | % de la population active |
| Population totale | `SP.POP.TOTL` | Habitants |

**Période interrogée :** `2015:2026`. **Période des observations présentes lors des tests :** `2015–2025`. L'année 2026 ne disposait pas encore de valeurs annuelles dans les réponses testées.

### Résultats mesurés dans SQL Server — couche Silver

| Indicateur | Observations | Pays | Années | Valeurs `NULL` |
|---|---:|---:|---|---:|
| PIB | 66 | 6 | 2015–2025 | 0 |
| Inflation | 66 | 6 | 2015–2025 | 1 |
| Chômage | 66 | 6 | 2015–2025 | 0 |
| Population | 66 | 6 | 2015–2025 | 0 |
| **Total** | **264** | **6** | **2015–2025** | **1** |

**Valeur manquante constatée :** `USA / 2025 / FP.CPI.TOTL.ZG / NULL`.

## 4. Architecture réalisée

```text
World Bank Indicators API V2
             │ HTTPS / JSON
             ▼
Qlik Talend Studio 8 (Windows)
  ├─ tHTTPClient : appels REST
  ├─ tExtractJSONFields : parsing JSON
  ├─ tReplicate / tLogRow : contrôle des flux
  ├─ tMap : mapping des données
  └─ tDBOutput : chargement SQL Server
             │ JDBC / authentification Windows
             ▼
Microsoft SQL Server Express — WorldBankEconomicDB
  ├─ bronze.world_bank_raw
  │    └─ Données tabulaires ingérées depuis Talend
  └─ silver.economic_indicators
       └─ Clé unique métier, déduplication et contrôles
             │ Connecteur SQL Server (Import)
             ▼
Power BI Desktop
  └─ Tableau de bord des quatre indicateurs
```

La transformation **Bronze → Silver** et les contrôles qualité ont été exécutés au moyen de scripts SQL dans **SQL Server Management Studio 22 (SSMS)**. Aucune table Gold n'est annoncée comme livrée.

## 5. Technologies et environnement

| Technologie | Utilisation |
|---|---|
| World Bank Indicators API V2 | Source publique des indicateurs |
| Qlik Talend Studio 8, mise à jour R2026-09 | Extraction, parsing, mappings et chargement Bronze |
| Qlik Talend Cloud | Projet Studio et gestion de licence/collaboration |
| Microsoft SQL Server Express | Base de données locale |
| SSMS 22 | Scripts SQL, contrôles et administration |
| Power BI Desktop | Préparation et visualisation des données |
| Git / GitHub | Versionnement, commits et Pull Request |
| Java JDK | Environnement d'exécution des Jobs Talend |

**Environnement de développement :** Windows, instance SQL Server `localhost\SQLEXPRESS`, base `WorldBankEconomicDB`. Ces valeurs sont spécifiques à l'installation de démonstration et doivent être adaptées pour reproduire le projet.

## 6. Source et extraction API

Documentation officielle : [World Bank Indicators API](https://datahelpdesk.worldbank.org/knowledgebase/articles/889392).

Exemple de requête PIB :

```text
https://api.worldbank.org/v2/country/FRA;DEU;USA;CHN;JPN;IND/indicator/NY.GDP.MKTP.CD?format=json&date=2015:2026&per_page=1000
```

Les mêmes paramètres sont utilisés pour l'inflation (`FP.CPI.TOTL.ZG`), le chômage (`SL.UEM.TOTL.ZS`) et la population (`SP.POP.TOTL`). L'API publique utilisée ne requiert pas de jeton d'authentification.

Les réponses comportent des métadonnées puis un tableau d'observations. Talend utilise la boucle JSONPath `"$[1][*]"` pour parcourir les observations et extraire les champs requis.

## 7. Jobs Talend réalisés

Les huit Jobs ont été développés et validés par des exécutions locales :

| Job | Rôle |
|---|---|
| `JOB_01_WorldBank_GDP_Extraction` | Extraction et parsing du PIB |
| `JOB_02_WorldBank_Indicators_Extraction` | Extraction de l'inflation |
| `JOB_03_WorldBank_Unemployment_Extraction` | Extraction du chômage |
| `JOB_04_WorldBank_Population_Extraction` | Extraction de la population |
| `JOB_05_WorldBank_Bronze_Load` | Chargement du PIB dans Bronze |
| `JOB_06_WorldBank_Inflation_Bronze_Load` | Chargement de l'inflation dans Bronze |
| `JOB_07_WorldBank_Unemployment_Bronze_Load` | Chargement du chômage dans Bronze |
| `JOB_08_WorldBank_Population_Bronze_Load` | Chargement de la population dans Bronze |

Les Jobs de chargement utilisent notamment `tHTTPClient → tExtractJSONFields → tReplicate → tMap → tDBOutput`, avec une branche `tLogRow` pour inspecter les données.

**Dépôt technique :** [world-bank-talend-studio](https://github.com/datasifaw/world-bank-talend-studio).

## 8. Organisation des données SQL Server

Base : **`WorldBankEconomicDB`**.

### Bronze — `bronze.world_bank_raw`

| Colonne | Type SQL Server | Rôle |
|---|---|---|
| `id` | `BIGINT IDENTITY` | Identifiant technique |
| `country_code` | `VARCHAR(3)` | Pays |
| `year` | `INT` | Année |
| `indicator_code` | `VARCHAR(30)` | Indicateur |
| `value` | `FLOAT NULL` | Valeur éventuellement manquante |
| `loaded_at` | `DATETIME2` | Horodatage de chargement UTC |

### Silver — `silver.economic_indicators`

| Colonne | Type SQL Server | Rôle |
|---|---|---|
| `country_code` | `VARCHAR(3)` | Pays |
| `year` | `INT` | Année |
| `indicator_code` | `VARCHAR(30)` | Indicateur |
| `value` | `FLOAT NULL` | Valeur contrôlée |
| `updated_at` | `DATETIME2` | Horodatage de mise à jour UTC |

La table Silver possède une **clé primaire composée** `(country_code, year, indicator_code)` et une contrainte sur la plage d'années. Le chargement SQL Silver applique une sélection déterministe des observations et met à jour ou insère les lignes selon leur clé métier.

### Scripts SQL versionnés

| Script | Objet |
|---|---|
| `sql/01_create_database.sql` | Création de la base |
| `sql/02_create_bronze_table.sql` | Création de Bronze |
| `sql/03_deduplicate_bronze.sql` | Correction documentée des doublons PIB |
| `sql/04_create_silver_table.sql` | Création de Silver |
| `sql/05_load_silver.sql` | Nettoyage et chargement Bronze → Silver |
| `sql/06_quality_checks_silver.sql` | Vérifications de qualité |

## 9. Contrôles qualité et résultats

Des requêtes SQL ont été exécutées sur `silver.economic_indicators` pour vérifier :

| Contrôle | Résultat constaté |
|---|---|
| Couverture par indicateur | 66 observations et 6 pays par indicateur |
| Années présentes | 2015–2025 |
| Doublons `(pays, année, indicateur)` | Aucun détecté |
| Pays, années ou indicateurs hors périmètre | Aucun détecté |
| Valeurs économiques incohérentes selon les règles implémentées | Aucune détectée |
| Valeurs manquantes | 1 : inflation USA 2025 |
| Volume consolidé Silver | 264 observations |

Les règles de cohérence vérifient notamment que les valeurs non nulles de PIB et de population sont positives et que le taux de chômage se situe entre 0 et 100. Une inflation négative peut être économiquement valide : elle n'est pas automatiquement rejetée.

**Incident rencontré :** une réexécution du Job de chargement du PIB avait ajouté 66 doublons en Bronze. Ces lignes ont été identifiées et supprimées de façon contrôlée, avec un script SQL versionné. La clé primaire Silver protège contre les doublons logiques à ce niveau.

## 10. Tableau de bord Power BI

Power BI Desktop est connecté à `silver.economic_indicators` en **mode Import**, avec l'authentification Windows vers SQL Server Express.

Des colonnes de présentation ont été ajoutées dans Power Query : `country_name` et `indicator_name`.

Le tableau de bord comprend quatre visualisations :

1. **PIB par pays (2025)** : barres de comparaison en dollars US courants.
2. **Inflation par pays (2015–2025)** : courbes annuelles.
3. **Chômage par pays (2015–2025)** : courbes annuelles.
4. **Population par pays (2015–2025)** : évolution démographique.

Les filtres de visuel isolent les indicateurs pour éviter d'additionner des mesures de nature différente. La valeur manquante d'inflation américaine en 2025 reste vide.

**Rapport :** `powerbi/World_Bank_Economic_Dashboard.pbix` (si ce chemin est bien celui utilisé dans le dépôt principal).

> Le fichier `.pbix` peut contenir une copie des données importées et des informations techniques sur la connexion locale. Son contenu doit être vérifié avant de le partager publiquement ; les identifiants et secrets ne doivent jamais être publiés.

## 11. Dépôts GitHub et stratégie de branches

### Dépôt principal — Portfolio

**[datasifaw/world-bank-economic-data-pipeline](https://github.com/datasifaw/world-bank-economic-data-pipeline)**

Contient la documentation, les scripts SQL et les éléments de présentation Power BI. La branche principale utilisée pour les livrables est `main`.

### Dépôt technique — Talend Studio

**[datasifaw/world-bank-talend-studio](https://github.com/datasifaw/world-bank-talend-studio)**

Le développement a été réalisé sur la branche **`test-migration-r2026-09`**, créée pour tester la migration de Studio sans affecter `main`.

La **Pull Request #1 — « Intégration des Jobs Talend World Bank validés »** a été **fusionnée dans `main` le 14 octobre 2026**. GitHub indiquait **12 commits** intégrés et **187 fichiers modifiés**.

La branche de migration peut être conservée pour référence ; la version fusionnée est accessible depuis `main`.

## 12. Reproduire le projet

### Prérequis

- Windows, Java/JDK compatible et accès à une installation Talend Studio 8 fonctionnelle avec licence adaptée.
- Une instance Microsoft SQL Server accessible et SSMS pour exécuter les scripts.
- Power BI Desktop.
- Accès à l'API World Bank et aux dépôts GitHub.

### Procédure

1. Récupérer les scripts SQL du dépôt principal et les Jobs du dépôt technique Talend.
2. Configurer la connexion SQL Server locale, puis exécuter `01_create_database.sql`, `02_create_bronze_table.sql` et `04_create_silver_table.sql`.
3. Adapter dans les Jobs Talend les paramètres de connexion JDBC et d'authentification à l'environnement local.
4. Exécuter les Jobs d'extraction pour contrôler les réponses API, puis les Jobs de chargement Bronze **sur une table vide ou dans une stratégie de chargement contrôlée**.
5. Exécuter `05_load_silver.sql`, puis `06_quality_checks_silver.sql`.
6. Ouvrir le rapport Power BI, adapter sa source SQL Server et actualiser les données.

**Limite actuelle :** les Jobs Bronze utilisent l'action SQL **« Insérer »**. Ils ne sont **pas encore idempotents** : plusieurs exécutions sans purge/stratégie de fusion peuvent produire des doublons. Il ne faut donc pas les relancer librement sur les mêmes données. Le script `03_deduplicate_bronze.sql` documente un correctif appliqué au PIB, mais ne remplace pas un mécanisme générique d'ingestion idempotente.

Les valeurs publiées par la Banque mondiale peuvent évoluer lors de futures actualisations de l'API : les chiffres et volumes constatés ici correspondent aux tests réalisés en octobre 2026.

## 13. Difficultés techniques résolues

- **Configuration Talend Studio / JDK et licence Cloud :** adaptation de l'environnement local, activation de la licence et accès au projet partagé.
- **Migration Talend Studio R2026-09 :** travail sur branche Git dédiée, puis fusion de la Pull Request vers `main`.
- **Dépendances JSON :** installation des bibliothèques nécessaires à `tExtractJSONFields` et configuration de la boucle JSONPath.
- **Authentification SQL Server :** connexion JDBC à l'instance SQL Server Express locale, port TCP 1433 et authentification Windows intégrée. La bibliothèque `mssql-jdbc_auth-13.2.1.x64.dll` a été rendue accessible au processus Java.
- **Valeurs manquantes :** conservation du `NULL` de l'inflation pour les États-Unis en 2025.
- **Doublons Bronze :** détection puis suppression contrôlée de 66 doublons de PIB.
- **Power BI :** correction des filtres par visuel pour séparer les indicateurs et éviter les agrégations incorrectes.

## 14. Limites et améliorations futures

Cette version est **fonctionnelle pour le périmètre validé**. Les évolutions envisagées sont :

- Rendre les chargements Bronze **idempotents** (fusion, clé métier ou stratégie de remplacement contrôlé).
- Créer une **couche Gold** analytique, avec par exemple le PIB par habitant et une table consolidée pays-année.
- Ajouter un Job orchestrateur, des paramètres dynamiques et une planification automatique.
- Mettre en place des tests automatisés, des alertes et un suivi des exécutions.
- Ajouter des captures d'écran et un dictionnaire de données complet au dépôt.
- Améliorer la portabilité des paramètres de connexion et la documentation de déploiement.

## 15. Références

- [World Bank Open Data](https://data.worldbank.org/)
- [World Bank Indicators API](https://datahelpdesk.worldbank.org/knowledgebase/articles/889392)
- [Documentation Qlik Talend](https://help.qlik.com/)
- [Documentation Microsoft SQL Server](https://learn.microsoft.com/sql/)
- [Documentation Microsoft Power BI](https://learn.microsoft.com/power-bi/)
- [Dépôt technique Talend Studio](https://github.com/datasifaw/world-bank-talend-studio)

---

**Domaine :** Data Engineering · ETL · SQL · Data Quality · Business Intelligence  
**Statut :** version fonctionnelle validée, documentation et améliorations techniques en évolution.  
**Dernière mise à jour :** 14 octobre 2026.

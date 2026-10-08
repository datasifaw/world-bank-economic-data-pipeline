# World Bank Economic Data Pipeline

**End-to-End Data Engineering Project | Qlik Talend Cloud · REST API · Google BigQuery · SQL · Looker Studio**

![Project Status](https://img.shields.io/badge/Status-Planning-blue)
![Data Engineering](https://img.shields.io/badge/Domain-Data%20Engineering-0A66C2)
![Data Source](https://img.shields.io/badge/Data%20Source-World%20Bank%20API-00897B)
![Platform](https://img.shields.io/badge/ETL-Qlik%20Talend%20Cloud-orange)

## 1. Project Overview

This project aims to design and implement an **end-to-end cloud-based ETL pipeline** to collect, transform, validate, store, and analyze economic indicators from the World Bank Open Data API.

The solution is designed around Qlik Talend Cloud for data integration, Google BigQuery for analytical storage, SQL for data processing, and Looker Studio for business intelligence.

The project demonstrates practical Data Engineering skills, including:

- REST API data ingestion
- JSON parsing and schema normalization
- ETL pipeline development
- Data cleaning and transformation
- Data quality validation
- Cloud Data Warehouse integration
- SQL-based analytical modeling
- Data visualization and reporting
- Technical documentation and reproducibility

**Current status:** Project planning. Implementation, testing, and validation are pending.

## 2. Business Problem

Economic indicators are often distributed across multiple datasets and may contain missing values, inconsistent structures, and different measurement units.

This makes cross-country economic analysis difficult without a standardized data integration process.

The project addresses the following business question:

**How have GDP, inflation, unemployment, and population evolved across six major economies between 2015 and 2024?**

The objective is to consolidate these indicators into a structured analytical dataset that supports reliable comparisons and visual exploration.

## 3. Project Scope

### Countries

| Country | ISO Code |
|---|---|
| France | FRA |
| Germany | DEU |
| United States | USA |
| China | CHN |
| Japan | JPN |
| India | IND |

### Economic Indicators

| Indicator | World Bank Code | Unit |
|---|---|---|
| Gross Domestic Product | `NY.GDP.MKTP.CD` | Current US dollars |
| Inflation | `FP.CPI.TOTL.ZG` | Annual % |
| Unemployment | `SL.UEM.TOTL.ZS` | % of total labor force |
| Total Population | `SP.POP.TOTL` | People |

**Analysis period:** 2015–2024 (10 years)

**Expected source coverage:** 6 countries × 4 indicators × 10 years = 240 potential country-indicator-year observations.

This number represents the expected source combinations, not 240 guaranteed non-null values. The analytical table will contain up to 60 country-year combinations.

## 4. Technology Stack

| Technology | Role |
|---|---|
| World Bank REST API | Source data extraction |
| Qlik Talend Cloud | Pipeline design and orchestration |
| Talend HTTP Client | REST API ingestion |
| Talend transformations | Parsing, cleaning, and transformation |
| Google BigQuery | Cloud Data Warehouse |
| SQL | Analytical queries and data validation |
| Google Looker Studio | Data visualization |
| GitHub | Version control and documentation |

The target architecture is fully cloud-based, without requiring a locally installed SQL Server or Talend Studio.

**Implementation dependency:** The required connectors, cloud execution engine, and Google BigQuery access must be validated in the available trial environments.

## 5. Target Data Architecture

The proposed data flow is:

**World Bank REST API → Talend Cloud → Data Quality & Transformation → BigQuery → Looker Studio**

The solution follows a three-layer data architecture.

### Bronze Layer — Raw Data

Purpose: Preserve data extracted from the World Bank API.

Planned information:

- Raw API response
- Source API endpoint
- Country and indicator identifiers
- Extraction timestamp
- Ingestion batch identifier

### Silver Layer — Cleaned Data

Purpose: Standardize, validate, and normalize source records.

Planned operations:

- Parse nested JSON responses
- Extract relevant data fields
- Standardize ISO country codes
- Convert years and numeric values
- Identify and manage null values
- Detect duplicates
- Apply validation rules

### Gold Layer — Analytics-Ready Data

Purpose: Build a consolidated dataset for business intelligence.

Planned operations:

- Join indicators using country and year
- Consolidate economic indicators
- Calculate derived metrics
- Produce analytical tables
- Enable country comparisons and trend analysis

The physical implementation of these layers will be finalized after validating the Talend Cloud and BigQuery connections.

## 6. Data Source — World Bank API

The project uses the official **World Bank Indicators API V2**.

API documentation:

https://datahelpdesk.worldbank.org/knowledgebase/articles/889392

### Example API Request

GDP data for France, Germany, the United States, China, Japan, and India:

`https://api.worldbank.org/v2/country/FRA;DEU;USA;CHN;JPN;IND/indicator/NY.GDP.MKTP.CD?format=json&date=2015:2024&per_page=1000`

The API returns JSON containing pagination metadata and economic observations.

### Planned Ingestion Workflow

1. Send HTTP GET requests to the World Bank API.
2. Validate HTTP response status and JSON structure.
3. Inspect pagination metadata.
4. Extract indicator observations from the JSON response.
5. Preserve relevant source metadata.
6. Transform records into a structured tabular dataset.
7. Validate and load records into the target Data Warehouse.

The initial version will process a fixed historical period. Incremental ingestion and scheduling may be considered as future enhancements.

## 7. Data Transformation

The ETL pipeline will standardize data from multiple indicators into a common analytical structure.

### Target Gold Table: `fact_economic_indicators`

| Column | Proposed Type | Description |
|---|---|---|
| country_code | STRING | ISO alpha-3 country code |
| country_name | STRING | Country name |
| year | INT64 | Reference year |
| gdp_usd | FLOAT64 | GDP in current USD |
| inflation_pct | FLOAT64 | Annual inflation rate |
| unemployment_pct | FLOAT64 | Unemployment rate |
| population | INT64 | Total population |
| gdp_per_capita | FLOAT64 | GDP per capita |
| load_timestamp | TIMESTAMP | Data loading timestamp |

For this portfolio-scale project, a country-year analytical table will be used. A dimensional model can be introduced as a future enhancement.

### Derived Metric

**GDP per capita**

`GDP per Capita = GDP (USD) / Total Population`

The calculation will return NULL when the required data is missing or the population is zero.

All economic measurements will preserve their original definitions and units.

## 8. Data Quality Strategy

Data quality is an essential part of the project.

The pipeline will include the following validation rules:

| Quality Check | Validation Rule |
|---|---|
| Country completeness | Country code must not be null |
| Year completeness | Reference year must not be null |
| Year validity | Year must be between 2015 and 2024 |
| Country validity | Country code must belong to the six selected countries |
| Uniqueness — source | One record per country, year, and indicator |
| Uniqueness — Gold | One record per country and year |
| Type validation | Numeric indicators must be correctly typed |
| Missing values | Null economic measurements must be identified |
| Population validity | Non-null population must be greater than zero |
| Record reconciliation | Source, rejected, and loaded record counts must be reconciled |

Additional controls will distinguish missing values from zero values and detect unexpected changes in source records.

**Planned output:** A documented data quality summary describing passed and failed checks.

**Actual results:** Not yet available.

## 9. Data Warehouse — Google BigQuery

Google BigQuery is the proposed analytical storage platform.

The target warehouse will organize raw, cleaned, and analytics-ready data into separate logical layers.

### Proposed Datasets

- `world_bank_bronze`
- `world_bank_silver`
- `world_bank_gold`

### Proposed Gold Table

`world_bank_gold.fact_economic_indicators`

### Example Analytical Query

The following SQL illustrates a planned analysis of average inflation and unemployment by country:

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

Replace `PROJECT_ID` with the actual Google Cloud project identifier.

This query is illustrative and has not yet been executed against a populated project table.

## 10. Business Intelligence — Looker Studio

The planned dashboard will provide a comparative overview of economic performance.

### Planned Visualizations

**GDP Analysis**
- GDP evolution by country
- Country-level GDP comparison
- GDP per capita trends

**Inflation Analysis**
- Annual inflation trends
- Average inflation by country
- Comparison across selected years

**Unemployment Analysis**
- Unemployment evolution
- Cross-country unemployment comparison
- Inflation and unemployment trend exploration

**Population Analysis**
- Population growth trends
- Country-level population comparison

### Interactive Filters

- Country
- Year
- Economic indicator

**Dashboard status:** Not yet implemented.

The dashboard URL and screenshots will be added after successful development and validation.

## 11. Proposed Repository Structure

```text
world-bank-talend-cloud-etl/
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

This is the proposed structure. Pipeline definitions or export files will be included only if supported by the Talend Cloud environment used during implementation.

No API credentials, service account keys, passwords, or sensitive configuration files will be committed to the repository.

## 12. Four-Day Implementation Roadmap

### Day 1 — Environment Setup and API Ingestion

- [ ] Activate Qlik Talend Cloud trial
- [ ] Verify Pipeline Designer availability
- [ ] Validate cloud execution engine access
- [ ] Configure HTTP Client
- [ ] Connect to the World Bank API
- [ ] Validate JSON parsing
- [ ] Confirm BigQuery connectivity or select an alternative cloud destination

**Expected deliverable:** Working API ingestion proof of concept.

### Day 2 — Data Transformation and Quality

- [ ] Extract four economic indicators
- [ ] Normalize JSON records
- [ ] Standardize country and year fields
- [ ] Convert data types
- [ ] Identify duplicates and missing values
- [ ] Consolidate economic indicators
- [ ] Implement data quality checks

**Expected deliverable:** Cleaned and validated economic dataset.

### Day 3 — Data Warehouse and SQL Analytics

- [ ] Create BigQuery datasets and tables
- [ ] Load cleaned data
- [ ] Build the analytical Gold table
- [ ] Calculate GDP per capita
- [ ] Execute analytical SQL queries
- [ ] Validate record counts
- [ ] Test repeatable loading without unexpected duplicates

**Expected deliverable:** Queryable analytical dataset.

### Day 4 — Dashboard, Testing, and Documentation

- [ ] Build Looker Studio dashboard
- [ ] Add interactive filters
- [ ] Validate dashboard metrics against SQL queries
- [ ] Capture Talend pipeline screenshots
- [ ] Document challenges and solutions
- [ ] Finalize GitHub README
- [ ] Publish project deliverables

**Expected deliverable:** Documented end-to-end portfolio project.

The four-day schedule is a target and depends on trial access, connector availability, and successful integration testing.

## 13. Project Status and Results

### Current Development Status

**Phase:** Planning and architecture definition.

| Component | Status |
|---|---|
| Business requirements | Defined |
| Country selection | Defined |
| Economic indicators | Defined |
| Target architecture | Proposed |
| World Bank API ingestion | Not started |
| Talend ETL pipeline | Not started |
| Data quality implementation | Not started |
| BigQuery integration | Not started |
| SQL validation | Not started |
| Looker Studio dashboard | Not started |
| End-to-end testing | Not started |

### Expected Results

The project aims to deliver:

- A working cloud-based API ingestion pipeline
- Clean and standardized economic data
- A queryable analytical warehouse
- Implemented and documented data quality rules
- SQL analyses of economic indicators
- An interactive economic dashboard
- A reproducible GitHub portfolio project

### Actual Results

No extraction, pipeline execution, warehouse load, or dashboard validation has been performed yet.

Once the project is implemented, this section will report:

- Actual source records received
- Successfully processed records
- Missing and rejected records
- Number of records loaded
- Validation results
- Pipeline execution outcomes
- Dashboard URL and screenshots

Only observed and verified results will be reported.

## 14. Challenges and Engineering Decisions

The following technical areas will be evaluated during implementation:

- Parsing the World Bank API response structure
- Managing API pagination and missing observations
- Applying consistent data types across indicators
- Combining multiple economic datasets by country and year
- Ensuring repeatable loads without unintended duplicates
- Configuring secure Talend-to-BigQuery connectivity
- Working within cloud trial limitations

Solutions and lessons learned will be documented after implementation, rather than presented as completed work.

## 15. Future Improvements

Potential future enhancements include:

- Parameterized country and year selection
- Incremental data ingestion
- Automated pipeline scheduling
- Pipeline monitoring and failure alerts
- Additional economic indicators
- Data quality trend monitoring
- Dimensional data modeling
- Automated validation and deployment

These features are outside the initial four-day project scope.

## 16. Data Source and References

**World Bank Open Data**

https://data.worldbank.org/

**World Bank Indicators API**

https://datahelpdesk.worldbank.org/knowledgebase/articles/889392

**Qlik Talend Documentation**

https://help.qlik.com/

**Google BigQuery Documentation**

https://cloud.google.com/bigquery/docs

**Looker Studio**

https://lookerstudio.google.com/

Economic data is provided by the World Bank. Indicator definitions, sources, and licensing conditions should be reviewed before redistribution.

## 17. Project Purpose

This project is developed as a **Data Engineering portfolio project** to demonstrate the design and implementation of a cloud-based data integration workflow.

It focuses on practical experience with REST APIs, ETL transformations, cloud storage, SQL analytics, data quality, and technical documentation.

The objective is to deliver an understandable, testable, and well-documented data pipeline using modern Data Engineering practices.

---

**Project:** World Bank Economic Data Pipeline  
**Focus:** Data Engineering | ETL | Cloud Analytics  
**Status:** Planning — Implementation Pending

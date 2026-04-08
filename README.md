# 🚗 Used Car Analytics Platform – End‑to‑End Azure Data Engineering Project
## 📌 Project Overview

This project is a real‑world, end‑to‑end data engineering and analytics solution built around the used car marketplace domain.
The use case is inspired by real business questions faced by the used car buying & selling community, such as pricing trends, listing quality, demand patterns, and feature impact on car value.

To simulate a production‑grade system, real data was scraped from PakWheels, ingested into Azure Data Lake, processed using a Medallion Architecture (Bronze–Silver–Gold), and exposed for analytics via Synapse Serverless SQL and BI tools (Power BI / Tableau).

### 🎯 Business Objectives

The goal of this project is to enable data‑driven decisions for stakeholders by answering questions like:

What is the average price of used cars?
What is the average listing age?
What is the average price by brand (top brands)?
How does price vary by city?
Which car types dominate the market (SUV / Sedan / Hatchback)?
How is fuel type distribution shaping future demand?
What are the monthly listing and price trends?
Does missing or poor data quality affect how quickly a car sells?
Do cars with better features (safety, comfort, tech) sell at higher prices?
How do mileage buckets impact pricing?
Which listings are fast‑moving vs slow‑moving?

### 🏗️ High‑Level Architecture

<p align="center"> <img src="figures/highlevel_arch.png" width="900"> </p>

Pakwheels Website
        |
        | (Python Scraper – Selenium + BeautifulSoup)
        v
Azure Data Lake (Landing Zone - CSV)
        |
        | (Spark Data Quality & Validation)
        v
Landing/GoodDataFolder (Clean CSV)
        |
        | (ADF Copy Activity)
        v
Bronze Layer (Parquet, Snappy Compression)
        |
        | (Databricks – Cleaning, Business Rules)
        v
Silver Layer (Delta, Partitioned)
        |
        | (Databricks – Facts, Dimensions, SCD Type 2)
        v
Gold Layer (Delta – Analytics Ready)
        |
        | (Synapse Serverless External Tables)
        v
Power BI / Tableau / SQL Analytics


### 🔍 Data Source

#### Source: PakWheels (Used car listings)
##### Data Acquisition:

Python Web Scraping
Selenium (dynamic pages)
BeautifulSoup (HTML parsing)


#### Data Attributes:

Car details (brand, model, year, engine, fuel)
Features (safety, comfort, tech)
Pricing & mileage
Location
Listing timestamps

### 🧱 Medallion Architecture

#### 🔹 Landing Layer

Raw scraped data stored as CSV
No schema enforcement
Acts as the system of record

#### 🔹 Bronze Layer

Created using Azure Data Factory
Data copied from Landing GoodDataFolder
Stored as Parquet with Snappy compression
Minimal transformation
Incremental ingestion using watermarking

#### 🔹 Silver Layer

Processed using Azure Databricks
Major transformations applied:

Data quality checks
Data validation rules
Null handling & standardization
Typecasting
Business logic application

Stored as Delta tables
Partitioned for performance

#### 🔹 Gold Layer

Analytics‑ready data
Modeled using Star Schema
Includes:

Fact tables (car listings)
Dimension tables (car, date, location, features)

Slowly Changing Dimension (SCD Type 2) implemented using hash‑based change detection
Stored as Delta format


### 🧩 Dimensional Modeling
##### ✅ Fact Table

###### fact_listings
Grain: 1 row = 1 car listing
Measures:

DemandPKR
Mileage
ListingAgeDays
CarAge


###### Foreign Keys:

car_dim_id
date_dim_id
location_dim_id
car_features_dim_id

#### ✅ Dimension Tables

dim_car (SCD‑2)
dim_date
dim_location
dim_car_features

Each dimension uses surrogate keys and is built for analytical consistency.

### ♻️ Incremental Processing Strategy
✔ Watermark‑based incremental ingestion from source
✔ Delta Lake handles upserts and versioning gracefully
✔ No full reloads required
✔ Pipeline executes every 4 hours

### 🔐 Security & Governance

Azure Key Vault
  Stores secrets and sensitive connection strings
Managed Identity
  Secure service‑to‑service authentication
IAM / RBAC
  Role‑based access control
No secrets hard‑coded

### 🚨 Monitoring & Alerts

Azure Data Factory
Orchestration & pipelines
Azure Logic Apps
Alerts on pipeline failure
Notifications for operational issues

### 🔌 Analytics & BI Integration

Synapse Serverless SQL
External tables created over Delta Lake
Enables direct SQL analytics
BI Tools Supported
Power BI
Tableau


#### Star schema exposed to BI
Clean joins
High performance
Business‑friendly model

### 📊 Sample Business Queries Enabled

Average price by city & brand
Monthly listing volume trend
Feature score vs price analysis
Data quality vs listing age
Mileage vs price buckets
Fast‑moving vs slow‑moving inventory

### 🧠 Key Learnings & Highlights

Built a production‑grade medallion architecture
Implemented incremental pipelines end‑to‑end
Applied SCD Type‑2 correctly in Delta Lake
Designed BI‑ready dimensional models
Integrated security, alerting, governance
Worked with real, messy, scraped data

### 🚀 Future Enhancements

Add ML models (price prediction, demand forecasting)
Implement Data Quality metrics framework
Create feature importance analysis
Introduce row‑level security in Power BI
Optimize performance using Z‑ORDER and OPTIMIZE

### 🧑‍💻 Tech Stack

Python (Selenium, BeautifulSoup)
Azure Data Lake Storage Gen2
Azure Data Factory
Azure Databricks
Azure Synapse (Serverless SQL)
Delta Lake
Power BI / Tableau
Azure Key Vault
Azure Logic Apps

### ✅ Conclusion
This project demonstrates end‑to‑end data engineering capability, from raw real‑world data ingestion to analytics & business insights, following modern cloud and data architecture best practices.

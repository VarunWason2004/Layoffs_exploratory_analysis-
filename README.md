# Layoffs_exploratory_analysis-
A comprehensive SQL data engineering and analysis pipeline featuring robust data cleaning, data imputation, and advanced exploratory data analysis (EDA) tracking global tech industry layoff trends.
# Global Tech Layoffs: End-to-End SQL Data Engineering & Analysis Pipeline

## Project Overview
This repository contains a comprehensive, production-grade SQL data pipeline split into two distinct phases: **Data Cleaning** and **Exploratory Data Analysis (EDA)**. Utilizing a real-world dataset tracking thousands of corporate tech layoffs globally, this project simulates the full lifecycle of a data analyst or engineer dealing with raw, imperfect operational metrics.

The goal is twofold: first, sanitize the data to establish an institutional-grade source of truth; second, perform deep-dive exploratory analytics to reveal market anomalies, macroeconomic trends, and temporal progressions across the tech sector.

## Tech Stack & Core Concepts
* **Database Management System:** MySQL / SQL Server
* **Advanced SQL Techniques:** Common Table Expressions (CTEs), Window Functions (`DENSE_RANK()`, `ROW_NUMBER()`), Rolling/Running Aggregations, String Modification, Self-Joins, and Spatial Type-Casting.

---

## Phase 1: Automated Data Cleaning & ETL Pipeline
*File: `data_cleaning_pipeline.sql`*

Before running analytics, a multi-step staging script was implemented to ensure structural integrity:
1. **Deduplication:** Applied a `ROW_NUMBER()` window function partitioned across all metrics to isolate and delete absolute duplicate entries.
2. **Text Standardization:** Sanitized text inconsistencies using `TRIM()`, resolved trailing punctuation typos, and compressed overlapping categories (e.g., merging 'Crypto Currency' and 'CryptoCurrency' into 'Crypto').
3. **Null Handling & Normalization:** Converted literal text `'NULL'` errors into relational `NULL` values.
4. **Temporal Transformation:** Standardized text string elements into proper date records using `STR_TO_DATE()` before permanently mutating the schema structure into a native `DATE` datatype.
5. **Data Imputation:** Performed relational self-joins (`UPDATE JOIN`) to programmatically populate missing industry classification records based on corresponding company historical values.

---

## Phase 2: Exploratory Data Analysis (EDA)
*File: `layoffs_exploratory_analysis.sql`*

With a pristine database established, advanced queries were written to uncover hidden macroeconomic insights:

1. **Extreme Values & Failures:** Isolated metrics tracking the highest single-day layoffs and cross-referenced complete business closures (`percentage_laid_off = 1`) against total venture capital funding raised to spot massive startup failures.
2. **High-Level Categorical Aggregations:** Grouped total layoffs utilizing `SUM()` and `GROUP BY` layers to identify the hardest-hit corporate entities, regional Tech hubs (cities/countries), and industrial verticals (e.g., Retail, Consumer, Crypto).
3. **Time-Series Progression:** Formatted operational dates to chart layoffs chronologically by year and month to pinpoint exactly when macroeconomic pressures peaked.
4. **Advanced Temporal Rankings:** Developed a multi-layered CTE combining `SUM()` with a `DENSE_RANK() OVER (PARTITION BY year ORDER BY total_laid_off DESC)` window function to dynamically extract the top 3 corporations displaying the heaviest employee reductions for *each individual calendar year*.
5. **Rolling Totals Analysis:** Implemented a cumulative window function execution (`SUM(total) OVER (ORDER BY dates)`) to construct a month-over-month rolling aggregate, demonstrating the continuous velocity of job losses across the entire duration of the economic downturn.

## How to Deploy and Run
1. Execute the `data_cleaning_pipeline.sql` script to ingest the raw `layoffs.csv` and generate the verified `world_layoffs.layoffs_staging2` table.
2. Run the queries inside `layoffs_exploratory_analysis.sql` sequentially to generate reports on industry trends, time-series projections, and corporate rankings.

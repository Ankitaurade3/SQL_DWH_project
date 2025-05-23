
Building a modern datawarehouse with SQL server, including ETL processes, data modeling and analytics.
# Modern Data Warehouse Project – Medallion Architecture (Reused Sales Data)

## 📖 Project Overview

This project demonstrates the implementation of a modern data warehouse using **Medallion Architecture** — comprising Bronze, Silver, and Gold layers. The solution focuses on consolidating and analyzing sales data from CRM and ERP systems, enabling stakeholders to gain actionable business insights.

---

## 🔁 Architecture Overview

- **Bronze Layer**  
  Raw data is imported *as-is* from source CSV files into the PostgreSQL database.

- **Silver Layer**  
  Cleaned, standardized, and normalized data prepared for analytical purposes.

- **Gold Layer**  
  Business-ready, curated data modeled into a **star schema** (fact & dimension tables), ready for reporting and analytics.

---

## 🔧 Project Components

### 🧱 Data Architecture
- Designed a robust data pipeline following the Medallion Architecture.
- Defined and documented data flows and models using **draw.io** diagrams.

### 🔁 ETL Pipelines
- Built ETL pipelines to extract, transform, and load raw sales and customer data from CSV files to PostgreSQL.
- Cleaned and joined data from CRM and ERP systems into integrated tables.

### 📊 Data Modeling
- Created **Fact** and **Dimension** tables optimized for analytical queries.
- Applied star schema design patterns for performance and simplicity.

### 📈 Analytics & Reporting
- Developed SQL queries and views to extract insights around:
  - Customer purchasing behavior
  - Product performance by category
  - Regional and temporal sales trends

---

## 🛠️ Tools & Technologies

| Tool         | Purpose                                  |
|--------------|-------------------------------------------|
| CSV Files     | Source data from ERP & CRM               |
| PostgreSQL    | Database engine for the warehouse        |
| pgAdmin       | GUI for PostgreSQL development           |
| GitHub        | Version control & project collaboration  |
| draw.io       | Visualizing architecture & data models   |
| Notion        | Project documentation & tracking         |

---



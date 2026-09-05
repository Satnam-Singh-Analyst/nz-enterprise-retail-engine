# 🇳🇿 NZ Enterprise Retail & E-Commerce Logistics Engine (PostgreSQL)

![PostgreSQL Version](https://img.shields.io/badge/PostgreSQL-18.0-blue?logo=postgresql)
![Compliance](https://img.shields.io/badge/Compliance-15%25_NZ_GST-green)
![Domain](https://img.shields.io/badge/Domain-Retail_%26_Logistics_Analytics-orange)

## 📌 Business Overview
This project presents a normalized (3NF) relational database schema and production-grade SQL analytics suite engineered specifically for the New Zealand retail and e-commerce landscape. Designed to model multi-region logistics, sales transactions, customer segmentation, and compliance tracking, the system solves core business challenges around:

* **GST Compliance:** Automated tax liability calculations based on New Zealand's standard 15% Goods and Services Tax (GST) framework.
* **Fraud & Velocity Monitoring:** Real-time flagging of rapid multi-order anomalies placed within short time windows using SQL window functions.
* **Moving Averages & Payment Trends:** 7-day rolling revenue tracking and EFTPOS payment channel adoption metrics across local North and South Island hubs.

---

## 📐 Database Architecture (3NF Schema)

The database consists of 5 normalized tables connected through primary and foreign key constraints to ensure strict data integrity.

```text
                  ┌─────────────────┐
                  │   nz_regions    │
                  └────────┬────────┘
                           │ 1:N
                  ┌────────┴────────┐
                  │    customers    │
                  └────────┬────────┘
                           │ 1:N
  ┌──────────────┐1:N ┌────┴────┐ 1:N ┌──────────────┐
  │   products   ├───┤order_items├───┤    orders    │
  └──────────────┘    └─────────┘     └──────────────┘
```


### Entity Specifications

1. **nz_regions**: Regional taxation reference table storing North/South Island classifications and standard 15% GST baseline rates.
2. **customers**: Customer profiles containing tier classifications (Standard, Gold, Corporate) linked to regional locations.
3. **products**: Inventory catalog with NZD unit pricing and stock quantities across major retail categories (Apparel, Electronics, Furniture, Office, Groceries).
4. **orders**: Transaction records capturing payment methods (EFTPOS, Credit Card, Bank Transfer, Afterpay), precise timestamps, and status (COMPLETED, CANCELLED, REFUNDED).
5. **order_items**: Junction table mapping line-item quantities and historical purchase unit prices to specific orders with cascading deletes.

---

## 📊 Analytical SQL Suite

The queries.sql script contains production-ready queries built to extract actionable business intelligence:

### 1. Regional Sales & 15% NZ GST Tax Breakdown
Calculates gross sales, net revenue, and 15% GST tax liabilities per region:

### 2. Customer Spend Quartiles (NTILE & DENSE_RANK)
Ranks customers by revenue output and segments them into 4 spend quartiles to identify high-value enterprise accounts.

### 3. Rapid Transaction Velocity & Fraud Flagging (LAG + EXTRACT EPOCH)
Detects suspicious ordering behavior by calculating time intervals between consecutive purchases per customer and flagging instances where multiple high-value orders occur within 5 minutes.

### 4. 7-Day Moving Average & EFTPOS Adoption (ROWS BETWEEN + NULLIF)
Tracks revenue momentum via a 7-day rolling sales average and monitors EFTPOS adoption percentages safely handling zero-order days.

### 5. Dead Inventory Audit (EXCEPT Set Operator)
Executes set operations to immediately isolate products from the catalog that have generated zero sales activity.

---

## 🛠️ Installation & Local Setup

### Prerequisites
* PostgreSQL 15+ (tested on PostgreSQL 18)
* pgAdmin 4 or any SQL client CLI

### Execution Steps
1. Clone this repository:
   git clone https://github.com/Satnam-Singh-Analyst/nz-enterprise-retail-engine.git
   cd nz-enterprise-retail-engine

2. Open your SQL client and create a new database:
   CREATE DATABASE nz_retail_db;

3. Connect to nz_retail_db and execute the SQL scripts in this exact sequence:
   schema.sql
   seed.sql
   queries.sql

---

## 🛠 Tech Stack & Key SQL Concepts
* RDBMS: PostgreSQL
* Schema Design: 3rd Normal Form (3NF), Primary/Foreign Key Constraints, Check Constraints
* Analytics Techniques: CTEs, Window Functions (LAG, NTILE, DENSE_RANK), Moving Averages (ROWS BETWEEN), Conditional Aggregation (FILTER), Date Math (EXTRACT EPOCH), Set Operators (EXCEPT)

---

## 👤 Author
Satnam Singh
* Master of Arts (Economics) Student | Massey University
* LinkedIn: https://www.linkedin.com/in/satnam-singh-3b124a230/
* Focus: Business Intelligence, Retail Data Analytics, SQL Database Architecture & Financial Modeling

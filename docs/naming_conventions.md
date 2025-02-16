# Data Warehouse Naming Conventions

This document outlines the naming conventions for schemas, tables, views, columns, and other objects in the Data Warehouse, ensuring clarity and consistency for all stakeholders. Adhering to these conventions ensures consistency, clarity, and maintainability across the Data Warehouse.
---

## Table of Contents

1. [General Principles](#general-principles)
2. [Table Naming Conventions](#table-naming-conventions)
   - [Bronze Layer](#bronze-layer)
   - [Silver Layer](#silver-layer)
   - [Gold Layer](#gold-layer)
3. [Column Naming Conventions](#column-naming-conventions)
   - [Surrogate Keys](#surrogate-keys)
   - [Technical Columns](#technical-columns)
4. [Stored Procedure Naming Conventions](#stored-procedure-naming-conventions)

---

## General Principles

- **Naming Style**: Use `snake_case` for all names, with lowercase letters and underscores (`_`) to separate words.
- **Language**: All names must be in English.
- **Reserved Words**: Avoid using SQL reserved words as object names.

---

## Table Naming Conventions

### Bronze Layer
- Table names must start with the source system name and retain the original table name from the source system.
- **Format**: `<sourcesystem>_<entity>`  
  - `<sourcesystem>`: Name of the source system (e.g., `crm`, `erp`).  
  - `<entity>`: Exact table name from the source system.  
  - **Example**: `crm_customer_info` → Represents customer information from the CRM system.

### Silver Layer
- Table names must start with the source system name and retain the original table name from the source system.
- **Format**: `<sourcesystem>_<entity>`  
  - `<sourcesystem>`: Name of the source system (e.g., `crm`, `erp`).  
  - `<entity>`: Exact table name from the source system.  
  - **Example**: `crm_customer_info` → Represents customer information from the CRM system.

### Gold Layer
- Table names must use meaningful, business-aligned names and start with a category prefix.
- **Format**: `<category>_<entity>`  
  - `<category>`: Describes the table's role, such as `dim` (dimension) or `fact` (fact table).  
  - `<entity>`: Descriptive name of the table, aligned with the business domain (e.g., `customers`, `products`, `sales`).  
  - **Examples**:
    - `dim_customers` → Dimension table for customer data.  
    - `fact_sales` → Fact table containing sales transactions.  

#### Category Prefixes

| Prefix      | Description                       | Examples                              |
|-------------|-----------------------------------|---------------------------------------|
| `dim_`      | Dimension table                  | `dim_customer`, `dim_product`         |
| `fact_`     | Fact table                       | `fact_sales`                          |
| `report_`   | Report table                     | `report_customers`, `report_sales_monthly` |

---

## Column Naming Conventions

### Surrogate Keys  
- Primary keys in dimension tables must use the suffix `_key`.
- **Format**: `<table_name>_key`  
  - `<table_name>`: Refers to the name of the table or entity the key belongs to.  
  - `_key`: Suffix indicating that the column is a surrogate key.  
  - **Example**: `customer_key` → Surrogate key in the `dim_customers` table.

### Technical Columns
- Technical columns must start with the prefix `dwh_`, followed by a descriptive name indicating the column's purpose.
- **Format**: `dwh_<column_name>`  
  - `dwh`: Prefix reserved for system-generated metadata.  
  - `<column_name>`: Descriptive name indicating the column's purpose.  
  - **Example**: `dwh_load_date` → System-generated column storing the date when the record was loaded.

---

## Stored Procedure Naming Conventions

- Stored procedures used for loading data must follow the naming pattern:
- **Format**: `load_<layer>`  
  - `<layer>`: Represents the layer being loaded, such as `bronze`, `silver`, or `gold`.  
  - **Examples**:
    - `load_bronze` → Stored procedure for loading data into the Bronze layer.
    - `load_silver` → Stored procedure for loading data into the Silver layer.

---


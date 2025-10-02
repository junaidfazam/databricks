# Delta Live Tables (DLT) in Databricks

Delta Live Tables (DLT) is a framework in Databricks for building, managing, and orchestrating reliable ETL pipelines using declarative definitions.  

It simplifies how data engineers create pipelines by automatically handling:

- Data ingestion  
- Data transformations  
- Pipeline orchestration  
- Quality enforcement  
- Monitoring & recovery  

Instead of writing complex job workflows, you declare what transformations should happen, and Databricks manages the *how*.

---

## Why Use `LIVE` in DLT?

Because DLT is declarative, `LIVE` tells the pipeline engine:

> *“This table/view is part of my pipeline, not an external object.”*

### 1. Dependency Tracking (Lineage)
```sql
CREATE OR REFRESH LIVE TABLE silver_orders
AS SELECT * FROM LIVE.bronze_orders;
```
- `LIVE.bronze_orders` signals that **`silver_orders` depends on `bronze_orders`**.  
- Without `LIVE`, DLT assumes it’s a normal external table and ignores dependencies.

---

### 2. Automatic Orchestration
- ✅ With `LIVE`: DLT infers order automatically → **Bronze → Silver → Gold**.  
- ❌ Without `LIVE`: DLT may run in the wrong order or fail with *“table not found”*.

---

### 3. Data Quality & Monitoring
- Only `LIVE` tables/views show up in the DLT UI with:
  - Validation results  
  - Data quality stats  
  - Refresh logs  

---

### 4. Clear Separation of Scope
- `LIVE` = **Pipeline-scoped object** (defined inside DLT pipeline).  
- No `LIVE` = **External object** (Hive Metastore, Unity Catalog, or raw data).  

---

✅ **In SQL DLT**: Always use `LIVE.<table_name>`  
✅ **In Python DLT**: Always use `dlt.read("<table_name>")` or `dlt.read_stream()`  

---

## Example Code

### SQL Example
```sql
CREATE OR REFRESH LIVE TABLE gold_orders
AS
SELECT customer_id, SUM(amount) AS total
FROM LIVE.silver_orders
GROUP BY customer_id;
```

### Python Example
```python
import dlt

@dlt.table
def bronze_orders():
    return spark.read.json("/mnt/data/orders.json")

@dlt.table
def silver_orders():
    return dlt.read("bronze_orders").filter("amount > 0")
```

---

## Table Types in Databricks & DLT

### 1. Managed Table
- Databricks manages metadata + storage.  
- Default in DLT.  
- Dropping removes **both metadata + data**.  

**Example (SQL):**
```sql
CREATE OR REFRESH LIVE TABLE customers_bronze
AS SELECT * FROM cloud_files("/mnt/data/customers", "csv");
```

**Example (Python):**
```python
import dlt

@dlt.table
def customers_bronze():
    return spark.read.csv("/mnt/data/customers.csv", header=True)
```

---

### 2. External Table
- Data stored in user-specified location.  
- Dropping removes **metadata only** (files remain).  
- Useful for shared raw data.  

**Example:**
```sql
CREATE OR REFRESH LIVE TABLE external_sales
LOCATION "/mnt/external/sales"
AS SELECT * FROM cloud_files("/mnt/raw/sales", "csv");
```

---

## Views in Databricks & DLT

### 1. Live View
- Logical, **not persisted**.  
- Recomputed on every query.  
- Used for intermediate transformations.  

**Example:**
```sql
CREATE OR REFRESH LIVE VIEW active_customers
AS SELECT * FROM LIVE.customers_bronze WHERE email IS NOT NULL;
```

---

### 2. Materialized View (⚠ not part of DLT, Databricks SQL only)
- Results stored like a table.  
- Incrementally refreshed.  
- Best for BI dashboards.  

**Example:**
```sql
CREATE MATERIALIZED VIEW gold_customer_summary
AS
SELECT customer_id, COUNT(*) AS order_count
FROM sales
GROUP BY customer_id;
```

---

## Bronze → Silver → Gold with DLT

**Sample Raw JSON (`orders.json`):**
```json
{"order_id": 1, "customer_id": "C001", "amount": 100, "status": "active"}
{"order_id": 2, "customer_id": "C002", "amount": 0, "status": "cancelled"}
{"order_id": 3, "customer_id": "C001", "amount": 250, "status": "active"}
```

### Bronze (Raw Ingest)
```sql
CREATE OR REFRESH STREAMING LIVE TABLE bronze_orders
AS SELECT * FROM cloud_files("/mnt/data/orders", "json");
```

### Silver (Cleaned / Validated)
```sql
CREATE OR REFRESH LIVE TABLE silver_orders
AS
SELECT order_id, customer_id, amount
FROM LIVE.bronze_orders
WHERE amount > 0;
```

### Gold (Business-Ready)
```sql
CREATE OR REFRESH LIVE TABLE gold_customer_sales
AS
SELECT customer_id, SUM(amount) AS total_spent
FROM LIVE.silver_orders
GROUP BY customer_id;
```

### Live View (Intermediate)
```sql
CREATE OR REFRESH LIVE VIEW active_orders
AS SELECT * FROM LIVE.silver_orders WHERE status = 'active';
```

### Materialized View (BI Layer)
```sql
CREATE MATERIALIZED VIEW customer_sales_summary
AS SELECT * FROM gold_customer_sales;
```

---

## Quick Comparison

| Feature                | Managed Table (DLT default) | External Table            | Live View (DLT)      | Materialized View           |
| ---------------------- | --------------------------- | ------------------------- | -------------------- | --------------------------- |
| **Stored on disk**     | ✅ Yes                       | ✅ Yes                     | ❌ No                 | ✅ Yes                       |
| **Storage managed by** | Databricks                  | User (path)               | N/A                  | Databricks SQL engine       |
| **Refresh**            | Auto by pipeline            | Auto by pipeline          | On query             | Incremental                 |
| **Best for**           | Bronze/Silver/Gold layers   | Shared raw/curated data   | Temp transformations | BI aggregations             |

---

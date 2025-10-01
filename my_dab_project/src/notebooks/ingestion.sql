-- Databricks notebook source
-- MAGIC %python
-- MAGIC dbutils.widgets.text("catalog name","dev")
-- MAGIC catalog_name = dbutils.widgets.get("catalog name")

-- COMMAND ----------

-- MAGIC %python
-- MAGIC df= spark.sql(f" SELECT * FROM {catalog_name}.information_schema.catalogs")
-- MAGIC display(df)

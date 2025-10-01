# Databricks Bundle Setup Guide

This guide outlines the steps to create and manage Databricks bundles, jobs, variables, and pipelines.

---

## 1. Git Setup

1. In your **git folder** (example: `databricks`):
   - Create a feature branch:
     ```bash
     git checkout -b feature/dab_demo_1
     ```
   - Switch from `main` to `feature/dab_demo_1`.

   > **Note:** Folder name `databricks` in Git might be required.

2. Create a folder `notebooks` and add `notebook1` within it in Databricks.

---

## 2. Start Serverless Compute and Terminal

1. Start a **serverless compute** cluster.  
2. Open a **Web Terminal**:
   - Shortcut: `Ctrl + \``  
   - Or right-click bottom-left and select **Terminal**.
3. Navigate to the git folder:
   ```bash
   ls
   cd databricks
   ```

---

## 3. Running Commands without Profile Name

Run Databricks commands **without specifying the profile name**:

```bash
databricks bundle deploy --target dev
```

---

## 4. Using Parameters in Jobs

Inside a **notebook**:

```python
%python
dbutils.widgets.text("catalog_name", "dev")
catalog_name = dbutils.widgets.get("catalog_name")

df = spark.sql(f"SELECT * FROM {catalog_name}.information_schema.catalogs")
display(df)
```

---

## 5. Variables in Bundle

Create a `variables.yml` file inside the `resources` folder:

```yaml
variables:
  catalog_name:
    description: The ID of an existing cluster.
    default: dev
```

📖 Reference: [Databricks Bundle Variables](https://docs.databricks.com/aws/en/dev-tools/bundles/variables)

---

## 6. Jobs with Parameters

1. Create a job and use a parameter (`catalog_name`) with a default value.  
2. Copy job’s code into `jobs.yml` and update the catalog name:

```yaml
resources:
  jobs:
    dab_job_1:
      name: dab_job_1
      tasks:
        - task_key: dab_job_task_1
          notebook_task:
            notebook_path: /../../src/notebooks/ingestion.py
            base_parameters:
              catalog_name: ${var.catalog_name}
            source: WORKSPACE
      queue:
        enabled: true
      performance_target: PERFORMANCE_OPTIMIZED
```

---

## 7. Create ELT Pipeline

1. Create a new pipeline: **`dab_etl_pipline_1`**.  
2. Start with Python, create file `dab_transformaltion.py` in **transformation folder**:

```python
import dlt

@dlt.table
def transformed():
    return spark.range(10)
```

3. Run the code as **dry run**.  
4. Create a folder `pipelines/src` and move `dab_etl_pipline_1` root to this folder.

---

## 8. Pipeline Resources

1. Create a folder `pipelines/resources`.  
2. Copy the YAML code of pipelines into `pipelines.yml`.  
3. Update:
   - Relative path
   - Catalog name from variable

4. Add presets in `target` and deploy bundle.

---

## 9. Deployment with Variables

While deploying, you can provide variable values:

```bash
databricks bundle deploy --target prod --var catalog_name="prod"
```

---

✅ You now have a full setup for:
- Git branching  
- Variables management  
- Job execution with parameters  
- ELT pipeline creation & deployment  

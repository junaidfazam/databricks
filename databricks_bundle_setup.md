# Databricks CLI & Bundle Setup Guide

This document provides a step-by-step guide to install, configure, and use the **Databricks CLI** and **Bundles**.

---

## ⚙️ Install Databricks CLI

Official docs: [Databricks CLI Installation](https://docs.databricks.com/aws/en/dev-tools/cli/)

### Windows Installation (using Winget)

1. Search for Databricks CLI:

   ```powershell
   winget search databricks
   ```

2. Install CLI:

   ```powershell
   winget install Databricks.DatabricksCLI
   ```

3. Verify installation:

   ```powershell
   databricks -v
   ```

---

## 🔐 Authenticate with Databricks CLI

1. Open PowerShell and run:

   ```powershell
   databricks auth login --host <DATABRICKS_WORKSPACE_URL>
   ```

   Example:

   ```powershell
   databricks auth login --host https://dbc-e46923f7-f175.cloud.databricks.com/
   ```

2. Enter a **profile name** when prompted.  
3. A browser window will open → login with your Databricks credentials.  
4. On success, CLI shows:

   ```
   Profile successfully saved.
   ```

5. To list saved profiles:

   ```powershell
   databricks auth profiles
   ```

6. Profile details are saved in:

   ```
   C:\Users\<your_user>\.databrickscfg
   ```

   Example to open file:

   ```powershell
   notepad.exe C:\Users\junai\.databrickscfg
   ```

7. To see all commands:

   ```powershell
   databricks --help
   ```

---

## 📦 Create a Bundle

```bash
databricks bundle init --profile PROFILE_NAME
```

**Steps:**
1. Select a template (default: `python`).
2. Provide a project name (default: `my_project`).
3. Choose:
   - Include a sample notebook (yes/no).
   - Include a stub Lakeflow Declarative Pipeline (yes/no).
   - Include a stub Python package (yes/no).
   - Use serverless compute (yes/no).

```bash
cd my_project
```

---

## 📂 Project Structure

- Delete/add folders as needed.
- Update `databricks.yml` file accordingly.

---

## 🚀 Deploy a Bundle

```bash
databricks bundle deploy --profile PROFILE_NAME --target TARGET_NAME
```

Example:

```bash
databricks bundle deploy --profile junaid_dab --target dev
```

---

## ⚙️ Create a Job via Databricks UI

1. Create a job in the UI.
2. Switch to **YAML view** and copy the code.
3. In local project:
   - Create folder: `resources/job/`
   - Add file: `jobs.yml`
   - Paste job YAML.
   - Update relative paths (`../../` → use `/../` to go up).
4. Ensure `jobs.yml` is included in `databricks.yml`.
5. Redeploy bundle.

👉 Any job created will display:

```
This task was deployed as part of a bundle, avoid editing this copy, 
instead edit the source and redeploy the bundle.
```

---

## 🎛️ Custom Presets & Source Linked Deployment

### Default Preset
- Resources prefixed with `[dev my_user_name]`.
- Same as `[dev ${workspace.current_user.short_name}]`.
- Can be overridden.

### Modes

✅ **Development (default, source-linked)**  
- Jobs reference workspace notebooks directly.  
- Changes reflect instantly without redeployment.  
- Great for debugging & iteration.  

✅ **QA / Production (`source_linked_deployment: false`)**  
- Jobs reference bundled notebook copies.  
- Ensures reproducibility and stability.  

### Example in `databricks.yml`

```yaml
targets:
  dev:
    mode: development
    presets:
      name_prefix: "devenv ${workspace.current_user.short_name}"
      source_linked_deployment: false
```

---

## 📸 Deployment Snapshots

- Location:  

  ```
  my_project/.databricks/bundle/dev/sync-snapshots
  ```

- Tracks **NEW/UPDATED** files only.
- For deletions → delete `.databricks` folder and redeploy.

---

## 📋 Deployment Details

- **Summary:**
  ```bash
  databricks bundle summary --profile junaid_dab --target dev
  ```

- **Validate:**
  ```bash
  databricks bundle validate --profile junaid_dab --target dev
  ```

---

## 🌐 Deploy to Other Targets

Update `databricks.yml`:

```yaml
targets:
  prod:
    mode: production
    workspace:
      host: https://HOST_NAME
      root_path: FOLDER_PATH/.bundle/${bundle.name}/${bundle.target}
    permissions:
      - user_name: user_name
        level: CAN_MANAGE
```

---

## 🔄 Pulling Bundles from Databricks

❌ No `bundle pull` command exists.  

✅ Options:  
- Clone from Git (if bundle managed in Git).  
- Export workspace files (if bundle only exists in Databricks).  

---

## ✅ Best Practices

- Use **dev/source-linked** for iteration.  
- Use **QA/Prod** with `source_linked_deployment: false` for stability.  
- Commit configs to Git for reproducibility.  
- For clean deployments, delete `.databricks` before redeploying.  

---

📖 References:
- [Databricks Bundles](https://docs.databricks.com/aws/en/dev-tools/bundles/)
- [Databricks CLI](https://docs.databricks.com/aws/en/dev-tools/cli/)

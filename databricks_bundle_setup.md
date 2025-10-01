# Databricks Bundles – Quick Start Guide

This guide explains how to create, configure, and deploy Databricks Bundles.

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

- Delete or add folders as needed.
- Update the `databricks.yml` file accordingly.

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
3. In your local project:
   - Create a folder: `resources/job/`
   - Add file: `jobs.yml`
   - Paste the job YAML code.
   - Update relative paths using `../../` (use `/../` to go one folder up).
4. Ensure `jobs.yml` is included in `databricks.yml` resources.
5. Deploy the bundle again.

👉 The job will be created in Databricks.  
Jobs created via bundle will show a warning:

```
This task was deployed as part of a bundle, avoid editing this copy, 
instead edit the source and redeploy the bundle.
```

---

## 🎛️ Custom Presets & Source Linked Deployment

### Default Preset
- Deployed resources are prefixed with `[dev my_user_name]`.
- Equivalent to `[dev ${workspace.current_user.short_name}]`.
- You can override the name.

### Modes
✅ **Development (default, source-linked)**  
- Jobs reference actual workspace notebooks.  
- Changes are reflected immediately without redeploy.  
- Great for rapid iteration and debugging.  

✅ **QA / Production (`source_linked_deployment: false`)**  
- Jobs reference the bundled notebook copy.  
- Prevents unintended changes.  
- Ensures stability and reproducibility.  

### Example Preset in `databricks.yml`

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
- Tracks changes (NEW/UPDATED files only).
- For **deletions**, best practice is to delete `.databricks` and redeploy.

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

Add a new target in `databricks.yml`:

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

❌ There is **no `bundle pull` command**.  
✅ Options:
- Clone from Git (if bundle is source-controlled).  
- Export workspace files (if bundle only exists in Databricks).  

---

## ✅ Best Practices

- Use **development mode (source-linked)** for iteration.  
- Use **QA/Production mode** (`source_linked_deployment: false`) for stability.  
- Always **commit YAML configs** to Git for reproducibility.  
- For clean redeployments, delete `.databricks` before redeploying.  

---

📖 Reference: [Databricks Bundles Documentation](https://docs.databricks.com/aws/en/dev-tools/bundles/)

# Databricks Repo Setup with Azure DevOps

This guide explains how to create a new repo in **Azure DevOps**, attach it to **Databricks**, and manage changes between the two environments.

---

## 1. Create a New Repo in Azure DevOps

1. Go to [Azure DevOps](https://aex.dev.azure.com).
2. Create a **New Repository**.
3. While creating, add a **README** file (via Visual Studio or the portal).
4. Verify the **branch name** is `main`.
5. Click **Clone** to get the repository URL.
6. Generate a **Personal Access Token (PAT)**:
   - Use this token as the **password**.
   - Copy your **username** (from DevOps profile) and **token** (for authentication).
   - Save the repo URL for later.

---

## 2. Configure Git Credentials in Databricks

1. In Databricks, go to **Profile → Settings**.
2. Under **Git Integration**, select **Azure DevOps Services**.
3. Add **Git credentials**:
   - **Nickname**: Any identifier for your account.
   - **Username**: Azure DevOps user name.
   - **Password/Token**: Personal Access Token (PAT) from Azure DevOps.
4. For Github, Install databrick is required

---

## 3. Link Repo in Databricks

1. In Databricks **Workspace → Repos**, click **Create Repo**.
2. Enter:
   - **Git Provider**: Azure DevOps.
   - **Git URL**: Repository URL from Azure DevOps.
   - **Repository Name**: Name for your repo in Databricks.
3. The repo is now linked.

---

## 4. Working with Branches in Databricks

1. Go to **Workspace → Repos**.
2. Select the repo.
3. Click **Branch** → create a **new branch** (e.g., `feature/demo`).
4. Use **Pull** to fetch changes from Azure DevOps to Databricks.

---

## 5. Create Notebooks and Push Changes

1. Inside the repo in Databricks:
   - Select your feature branch (`feature/demo`).
   - Create a **folder** and a **notebook** inside it.
   - Choose **File → Notebook format → Source**.
2. To commit changes:
   - Click on **Branch**.
   - Select the notebook/file.
   - Add a commit **comment**.
   - Click **Commit & Push**.

---

## 6. Verify Changes in Azure DevOps

1. In Azure DevOps, switch to the branch you created (`feature/demo`).
2. Review the changes pushed from Databricks.
3. Continue normal development flow:
   - Create pull requests.
   - Merge back into `main`

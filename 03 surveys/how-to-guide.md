# Enforcing Developer Satisfaction Surveys via GitHub Actions

This guide explains how Organization Administrators can configure a GitHub Repository Ruleset to automatically request feedback via a Developer Satisfaction (DevSat) survey every time a new Pull Request is opened across the organization.

By configuring this at the organization level, you ensure all repositories inherit this behavior automatically without needing to commit a workflow file to every project.

## Step-by-Step Configuration Guide

### 1. Create the Central `.github` Repository
GitHub uses a special repository named `.github` to store organization-wide default files and workflows.
1. Create a new repository in your organization. Name it exactly `.github`.
2. Ensure this repository is accessible to other repositories in your organization (typically Internal or Public visibility).
3. Inside this repository, create the directory structure `.github/workflows/`.
4. Copy the `devsat-survey.yml` file from the `03 Surveys` folder into this new `.github/workflows/` directory.
5. Edit the `devsat-survey.yml` file to include your actual external survey URL (e.g., Google Forms, Qualtrics, Typeform).

### 2. Create the Organization Ruleset
Repository Rulesets allow admins to enforce that specific workflows *must* run.
1. As an Organization Admin, navigate to your Organization's **Settings**.
2. In the left sidebar, under the **Code, planning, and automation** section, select **Repository -> Rules -> Rulesets**.
3. Click **New branch ruleset**.
4. Give it a descriptive name, such as "Enforce DevSat Survey".
5. Set the Enforcement status to **Evaluate** (to test silently first) or **Active** (to enforce immediately).

### 3. Configure Targeting
Decide which repositories this survey should run on.
- Under **Target repositories**, select **Add target**.
- Choose **All repositories** to apply it everywhere, or use a **Dynamic list** / **Select repositories** to exclude specific repos (e.g., archived or documentation-only repos).
- Under **Target branches**, you typically want this to run on your default branch (e.g., `main` or `master`). Select **Include default branch**.

### 4. Require the Workflow
1. Scroll down to the **Rules** section and click **Add rule**.
2. Select **Require workflows to pass before merging**.
3. In the workflow selector configuration, click **Add workflow**.
4. Browse or type to select the `.github` repository you created in Step 1.
5. Select the `devsat-survey.yml` workflow file.
6. Click **Save** to create the ruleset.

## How it works
Once active, every time a developer opens a Pull Request in a targeted repository, GitHub will automatically trigger the `devsat-survey.yml` workflow from the central `.github` repository. 

The workflow uses GitHub Script to immediately post a comment on the PR containing a link to your survey. By appending the `context.issue.number` (PR number) and `context.actor` (PR author) to the URL query string, you can pre-fill information on the survey form to make it easier for the developer to complete.

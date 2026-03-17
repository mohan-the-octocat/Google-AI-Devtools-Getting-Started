# Gemini Code Assist (GCA) — AppDev Team Checklist

> This checklist covers the **code review, monitoring, and GitHub PR integration** best practices for Gemini Code Assist within your Enterprise environment. It is intended for Application Development teams responsible for code quality, CI/CD, and developer workflows.
>
> **Legend:**
> - ✅ **Enforceable within GCA Settings** — Can be configured via Google Cloud Console / Admin for Gemini / IAM / API settings / GCA repo config.
> - ⚠️ **Enforceable outside GCA Settings** — Requires external org-level controls (e.g., Google Workspace Admin, MDM, network firewalls, filesystem ACLs).
> - 🚫 **Not Enforceable** — Must be addressed via organizational policy, training, or external tooling (CI/CD, SAST, code review platforms).

---

## 1. Code Review & Quality Assurance 🛠️

| # | Checklist Item | Enforceability | Notes & Reference | Customer Notes |
|---|---|---|---|---|
| 1.1 | **Maintain Strict PR / Code Review Standards:** Do not bypass peer review for AI-generated code. Leverage the **GCA GitHub PR Review integration** (see Section 3) to add automated AI-powered code reviews to every pull request, ensuring consistent review coverage alongside human reviewers. | ⚠️ Enforceable outside GCA Settings | Automated AI review is provided by the [GCA GitHub App](https://github.com/marketplace/gemini-code-assist) (Enterprise). *Human review requirements must still be enforced via GitHub branch protection rules.* | |
| 1.2 | **Enforce Automated Security Scanning (SAST/DAST):** Ensure SAST/DAST is active in CI/CD pipelines. Optionally, use **Gemini CLI in headless mode** to auto-heal vulnerabilities flagged by SAST/DAST scans. For GitHub Actions workflows, use the [Gemini CLI GitHub Action](https://github.com/google-github-actions/run-gemini-cli) (`google-github-actions/run-gemini-cli`) to pipe scan results into Gemini for automated fix suggestions or PR creation. | ⚠️ Enforceable outside GCA Settings | *SAST/DAST tooling is external.* Gemini CLI headless mode (`gemini -p "<prompt>"`) can process scan output and generate remediation patches. The [Gemini CLI GitHub Action](https://github.com/google-github-actions/run-gemini-cli) enables this in CI/CD — trigger via `@gemini-cli` mentions or automated workflow events. | |
| 1.3 | **Require Automated Testing:** Mandate unit and integration tests for AI-generated logic. Consider using Gemini to *generate* test cases, but manually verify test assertions. | 🚫 Not Enforceable | *Test enforcement is a CI/CD pipeline concern.* GCA can help write tests via the "Write unit tests for my code" prompt. | |
| 1.4 | *(Reserved)* | | | |
| 1.5 | **Implement Gemini CLI Hooks for Workflow Enforcement:** Utilize [Gemini CLI hooks](https://geminicli.com/docs/hooks/#what-are-hooks) to enforce policies, add context, validate actions, log interactions, and optimize behavior. Hooks run synchronously during the agent loop, enabling robust customization and risk mitigation before models process requests. | ⚠️ Enforceable outside GCA Settings | *Configured via local Gemini CLI settings.* Hooks allow intercepting model calls to inject context (e.g., git history), validate tool arguments (blocking dangerous ops), or enforce security scanners. | |

---

## 2. Monitoring & ROI 📈

| # | Checklist Item | Enforceability | Notes & Reference | Customer Notes |
|---|---|---|---|---|
| 2.1 | **Track Adoption Metrics:** Monitor active seat usage, license allocation, and API call volume to measure ROI. | ✅ Enforceable within GCA Settings | Use the **Admin for Gemini** dashboard and Cloud Logging/BigQuery analytics. | |
| 2.2 | **Monitor Code Quality Impact:** Track bug density, code review rejection rates, and deployment frequency before and after GCA rollout. | 🚫 Not Enforceable | *Requires integration with your existing DevOps metrics tools (DORA, Jellyfish, LinearB, etc.).* | |
| 2.3 | **Establish a Developer Feedback Loop:** Create a mechanism to solicit feedback on the AI's impact. Consider creating a **GitHub Action or webhook** that automatically posts a short feedback form (e.g., Google Form) as a comment when a developer opens a new PR, gathering qualitative data on their experience using Gemini for that feature. | 🚫 Not Enforceable | *Organizational initiative.* GCA has a built-in in-IDE feedback mechanism (`feedback-pa.googleapis.com`) for product feedback to Google, but internal team feedback requires your own channels or custom CI/CD automation. | |

---

## 3. GitHub PR Review Integration (Enterprise) 🔀

### Overview

The Enterprise version of Gemini Code Assist includes an AI-powered **automated pull request reviewer** for GitHub. Once installed, `gemini-code-assist[bot]` is automatically added as a reviewer to new PRs, providing a summary and in-depth code review within ~5 minutes.

### Setup Steps

| Step | Action | Details |
|---|---|---|
| 1 | **Install the GitHub App** | Install [Gemini Code Assist](https://github.com/marketplace/gemini-code-assist) from the GitHub Marketplace. Select your GitHub **Organization** and choose which repositories to enable. |
| 2 | **Link to Google Cloud** | Complete setup in the **Admin Console for Gemini Code Assist**. Accept Google ToS, Generative AI Prohibited Use Policy, and Privacy Policy. |
| 3 | **Enable SCM Integration** | In the Admin Console **Agents** section, locate the **Code Assist Source Code Management** card and click **Enable**. Enable the **Gemini Code Assist Management API**. |
| 4 | **Create Developer Connect Connection** | Create a [Developer Connect](https://cloud.google.com/developer-connect/docs/overview) connection (typically in `us-east1`) to link your GitHub repositories. |
| 5 | **Grant IAM Roles** | Ensure administrators have the appropriate IAM roles in the Google Cloud project managing the GitHub integration. |

### Slash Commands Available in PR Comments

| Command | Action |
|---|---|
| `/gemini review` | Trigger a full code review |
| `/gemini summary` | Get a summary of PR changes |
| `/gemini help` | List all available commands |
| `/gemini <your question>` | Ask a contextual question about the PR |

### Org-Level Customization (Enterprise)

The Enterprise version supports **organization-wide configuration** that provides a centralized baseline across all repositories:

- **Org-level review settings** — Define default severity thresholds, review standards, and comment limits that apply to all repositories in your GitHub Organization. Individual teams can then layer repo-specific overrides on top.
- **Centralized "golden path"** — Establish a unified code quality standard that every repository inherits by default, reducing configuration drift and ensuring consistent review quality.

> [!NOTE]
> Org-level configuration is available only in the **Enterprise** version installed via the Google Cloud Admin Console. The consumer marketplace version does not support org-level controls.

### Per-Repository Customization

Create a **`.gemini/`** directory at the root of your repository to override or extend org-level defaults:

- **`.gemini/config.yaml`** — Control review behavior (enable/disable reviews, set comment severity thresholds, limit number of review comments).
- **`.gemini/styleguide.md`** — Document your team's coding standards; Gemini will reference this during reviews to enforce style and syntax feedback.

### Enterprise Checklist Items

| # | Checklist Item | Enforceability | Notes & Reference | Customer Notes |
|---|---|---|---|---|
| 3.1 | **Install GCA GitHub App (Enterprise) via Admin Console:** Install through Google Cloud for centralized control, higher quotas, and org-level configuration — not the consumer marketplace version. | ✅ Enforceable within GCA Settings | Enterprise version is managed via Google Cloud Admin Console, providing consolidated control across all repositories. | |
| 3.2 | **Define Org-Level Review Configuration:** Set a centralized "golden path" for code quality that is enforced across all repositories, defining baseline severity thresholds and review standards. | ✅ Enforceable within GCA Settings | Enterprise supports org-level controls. Individual teams can layer repo-specific `.gemini/config.yaml` and `styleguide.md` on top. | |
| 3.3 | **Create Per-Repo `.gemini/config.yaml`:** Configure review behavior per repository — enable/disable reviews, set minimum comment severity, and limit comment count. | ✅ Enforceable within GCA Settings | Managed via `.gemini/config.yaml` in the repo root. Maintainers control this file. | |
| 3.4 | **Create Per-Repo `.gemini/styleguide.md`:** Document team coding standards so Gemini can automate style and syntax feedback during PR reviews. | ✅ Enforceable within GCA Settings | Managed via `.gemini/styleguide.md` in the repo root. Plain markdown file describing coding conventions. | |
| 3.5 | **Restrict Repository Scope:** During installation, select **"Only select repositories"** rather than "All repositories" to control which repos have AI review enabled. | ✅ Enforceable within GCA Settings | Configured during GitHub App installation. Can be changed later in the GitHub App settings. | |
| 3.6 | **Train Developers on Slash Commands:** Ensure developers know how to interact with the bot (`/gemini review`, `/gemini summary`, etc.) and how to ask follow-up questions on review comments. | 🚫 Not Enforceable | *Training initiative.* The commands are built-in, but awareness requires documentation and onboarding. | |
| 3.7 | **Establish Policy for AI-Review-Only PRs:** Define whether the AI review alone is sufficient for any PR category, or whether human review is always required in addition. | 🚫 Not Enforceable | *Organizational policy.* GitHub branch protection rules (requiring human approval) can enforce this — not GCA itself. | |

> [!WARNING]
> **Logging Limitation:** Gemini Code Assist on GitHub **does not** currently support Cloud Logging. The prompt/response audit logging applies only to IDE interactions, not GitHub PR reviews.

---

## Key Reference Links

| Document | URL |
|---|---|
| GCA Overview (Standard & Enterprise) | https://cloud.google.com/gemini/docs/codeassist/overview |
| Data Governance | https://cloud.google.com/gemini/docs/discover/data-governance |
| Code Customization (Enterprise) | https://cloud.google.com/gemini/docs/codeassist/code-customization-overview |
| Use GCA in Your IDE | https://cloud.google.com/gemini/docs/codeassist/use-in-ide |
| GCA on GitHub Marketplace | https://github.com/marketplace/gemini-code-assist |
| Developer Connect | https://cloud.google.com/developer-connect/docs/overview |

---

## Enforceability Summary

| Category | ✅ Within GCA Settings | ⚠️ Outside GCA Settings | 🚫 Not Enforceable |
|---|---|---|---|
| Code Review & QA | 0 | 2 | 1 |
| Monitoring & ROI | 1 | 0 | 2 |
| GitHub PR Review (Enterprise) | 5 | 0 | 2 |
| **Total** | **6** | **2** | **5** |

> [!NOTE]
> This checklist should be reviewed periodically alongside [Google Cloud's official GCA documentation](https://cloud.google.com/gemini/docs/codeassist/overview), as features and compliance capabilities evolve.
> 
> For the companion **Infosec Team Checklist** covering Security, Access Control, and Logging, see [GCA_Infosec_Team_Checklist.md](./GCA_Infosec_Team_Checklist.md).

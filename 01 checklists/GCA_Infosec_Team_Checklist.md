# Gemini Code Assist (GCA) — Infosec Team Checklist

> This checklist covers the **security, access control, and observability** best practices for Gemini Code Assist within your Enterprise environment. It is intended for Information Security teams responsible for governance, compliance, and risk management.
>
> **Legend:**
> - ✅ **Enforceable within GCA Settings** — Can be configured via Google Cloud Console / Admin for Gemini / IAM / API settings / GCA repo config.
> - ⚠️ **Enforceable outside GCA Settings** — Requires external org-level controls (e.g., Google Workspace Admin, MDM, network firewalls, filesystem ACLs).
> - 🚫 **Not Enforceable** — Must be addressed via organizational policy, training, or external tooling (CI/CD, SAST, code review platforms).

---

## 1. Security & Data Privacy 🔒

| # | Checklist Item | Enforceability | Notes & Reference | Customer Notes |
|---|---|---|---|---|
| 1.1 | **Verify Data Governance Policies:** Confirm that Google does not use your prompts or responses to train its models — this is Google's default commitment for GCA. | ✅ Enforceable within GCA Settings | Google's [data governance commitment](https://cloud.google.com/gemini/docs/discover/data-governance): *"Gemini doesn't use your prompts or its responses as data to train its models."* No action needed; this is the baseline policy. | |
| 1.2 | **Configure VPC Service Controls (VPC-SC):** Define a service perimeter that includes the `Gemini for Google Cloud API` and `Gemini Code Assist API` to prevent data exfiltration. | ✅ Enforceable within GCA Settings | ➡️ [Configure VPC Service Controls for Gemini](https://cloud.google.com/gemini/docs/configure-vpc-service-controls). Enabling VPC-SC blocks all access from outside the perimeter, including IDE extensions. Configure ingress policies if developers work outside the perimeter. | |
| 1.3 | **Configure Firewall Rules for API Traffic:** Allow traffic only to required API domains (`cloudaicompanion.googleapis.com`, `oauth2.googleapis.com`, etc.) as documented in the setup guide. | ✅ Enforceable within GCA Settings | The [setup guide](https://cloud.google.com/gemini/docs/codeassist/set-up-gemini) lists the exact domains/IPs to allowlist. Configure your network firewall to permit only these endpoints. | |
| 1.4 | **Encrypt Data In-Transit:** Verify that prompts are encrypted in transit to the underlying model. | ✅ Enforceable within GCA Settings | Per [data governance docs](https://cloud.google.com/gemini/docs/discover/data-governance): *"your data is encrypted in-transit as input to the underlying model."* Leverages Google's [default encryption at rest](https://cloud.google.com/docs/security/encryption/default-encryption) and [encryption in transit](https://cloud.google.com/docs/security/encryption-in-transit). | |
| 1.5 | **Prevent Secrets/PII in Prompts:** Prevent developers from pasting API keys, hardcoded secrets, or PII into chat prompts. | ⚠️ Enforceable within GCA Settings | GCA does not have a built-in DLP filter for user prompts, however, you can leverage **Gemini CLI hooks** to implement automated secret scanning before prompts are sent to the model. See this blog post for an example: [Tailor Gemini CLI to your workflow with hooks](https://developers.googleblog.com/tailor-gemini-cli-to-your-workflow-with-hooks/). Consider these traditional tools to fill the gap in other workflows: **Free:** [gitleaks](https://github.com/gitleaks/gitleaks), [truffleHog](https://github.com/trufflesecurity/trufflehog), [detect-secrets](https://github.com/Yelp/detect-secrets), [git-secrets](https://github.com/awslabs/git-secrets). **Paid:** [GitHub Advanced Security (Secret Scanning)](https://docs.github.com/en/code-security/secret-scanning), [GitGuardian](https://www.gitguardian.com/), [Nightfall AI](https://www.nightfall.ai/), [Google Cloud DLP](https://cloud.google.com/sensitive-data-protection). | |

---

## 2. Access Control & IAM 👤

| # | Checklist Item | Enforceability | Notes & Reference | Customer Notes |
|---|---|---|---|---|
| 2.1 | **Implement Least Privilege IAM:** Grant `roles/cloudaicompanion.user` (Gemini for Google Cloud User) and `roles/serviceusage.serviceUsageConsumer` only to authorized developer groups. | ✅ Enforceable within GCA Settings | ➡️ [Grant IAM roles](https://docs.cloud.google.com/gemini/docs/codeassist/set-up-gemini#grant-iam). Configurable via Cloud Console or `gcloud` CLI. | |
| 2.2 | **Control License Assignment:** Choose between automatic and manual license assignment. For strict control, switch to manual license management in the Admin for Gemini page. | ✅ Enforceable within GCA Settings | ➡️ [Manage licenses](https://cloud.google.com/gemini/docs/codeassist/manage-licenses). Auto-assignment assigns a license when a user has `cloudaicompanion.licences.selfAssign` permission. Disable this permission for manual control. | |
| 2.3 | **Enforce SSO / MFA:** Require Single Sign-On and Multi-Factor Authentication for all developers authenticating from their IDEs. | ⚠️ Enforceable outside GCA Settings | GCA authenticates via Google Cloud identity (`oauth2.googleapis.com`). SSO/MFA is enforced at the **Google Workspace / Cloud Identity** level, not within GCA settings. | |
| 2.4 | **Centralized Gemini CLI & Plugin Deployment:** Deploy [Gemini CLI](https://github.com/google-gemini/gemini-cli) and the [VS Code Gemini CLI Companion Plugin](https://marketplace.visualstudio.com/items?itemName=Google.gemini-cli-vscode-ide-companion) via centralized device management (MDM) rather than ad-hoc installation. | ⚠️ Enforceable outside GCA Settings | CLI and plugin installation is managed at the OS/IDE level. *Requires MDM or endpoint management policies.* | |
| 2.5 | **MDM-Deploy Gemini CLI Policies File:** Push the Gemini CLI policies configuration file (see [`sample-policies.toml`](../02%20samples/sample-policies.toml) for an example) to developer workstations via MDM and enforce it as **read-only / uneditable** so developers cannot override organizational guardrails (e.g., allowed models, tool restrictions, safety settings). | ⚠️ Enforceable outside GCA Settings | The policies file is a Gemini CLI feature. *Deployment and write-protection must be enforced via MDM and filesystem ACLs.* | |
| 2.6 | **Enable and Review Cloud Audit Logs:** Track who accesses GCA and when they authenticate via Cloud Audit Logs. | ✅ Enforceable within GCA Settings | Standard Cloud Audit Logs apply. API calls to `cloudaicompanion.googleapis.com` are logged. | |

---

## 3. Logging & Observability 📊

| # | Checklist Item | Enforceability | Notes & Reference | Customer Notes |
|---|---|---|---|---|
| 3.1 | **Enable Prompt & Response Logging:** Turn on full logging in the Admin for Gemini console to capture user prompts, contextual code, and AI responses for auditability. | ✅ Enforceable within GCA Settings | ➡️ Navigate to **Admin for Gemini > Settings** and toggle "Logging for Code Assist prompts and responses." Requires `roles/cloudaicompanion.settingsAdmin`. | |
| 3.2 | **Enable Metadata Logging:** Record telemetry metadata (e.g., lines of code accepted) without capturing the full prompt/response payload for lighter-weight monitoring. | ✅ Enforceable within GCA Settings | Same Admin for Gemini Settings page. Toggle "Logging for Code Assist metadata." | |
| 3.3 | **Define Log Retention Policies:** Set appropriate retention periods for GCA logs in Cloud Logging aligned with your organization's data retention requirements. | ✅ Enforceable within GCA Settings | Configured via standard [Cloud Logging retention settings](https://cloud.google.com/logging/docs/routing/overview). | |

> [!IMPORTANT]
> **Limitation:** Logging for Gemini Code Assist is limited to user interactions within an IDE. Gemini Code Assist on GitHub does not currently support logging with Cloud Logging.

---

## Key Reference Links

| Document | URL |
|---|---|
| GCA Overview (Standard & Enterprise) | https://cloud.google.com/gemini/docs/codeassist/overview |
| Set Up Gemini Code Assist | https://cloud.google.com/gemini/docs/codeassist/set-up-gemini |
| Data Governance | https://cloud.google.com/gemini/docs/discover/data-governance |
| Configure VPC Service Controls | https://cloud.google.com/gemini/docs/configure-vpc-service-controls |
| Manage Licenses | https://cloud.google.com/gemini/docs/codeassist/manage-licenses |
| Responsible AI | https://cloud.google.com/gemini/docs/discover/responsible-ai |

---

## Enforceability Summary

| Category | ✅ Within GCA Settings | ⚠️ Outside GCA Settings | 🚫 Not Enforceable |
|---|---|---|---|
| Security & Data Privacy | 4 | 0 | 1 |
| Access Control & IAM | 3 | 3 | 0 |
| Logging & Observability | 3 | 0 | 0 |
| **Total** | **10** | **3** | **1** |

> [!NOTE]
> This checklist should be reviewed periodically alongside [Google Cloud's official GCA documentation](https://cloud.google.com/gemini/docs/codeassist/overview), as features and compliance capabilities evolve.
> 
> For the companion **AppDev Team Checklist** covering Code Review, Monitoring, and GitHub PR Review, see [GCA_AppDev_Team_Checklist.md](./GCA_AppDev_Team_Checklist.md).

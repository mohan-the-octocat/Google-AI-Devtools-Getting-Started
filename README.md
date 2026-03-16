# Google AI Devtools Getting Started

This repository provides resources, guidelines, and samples for getting started with Google AI Developer Tools, specifically focusing on Gemini Code Assist (GCA).

## Constituents

- **[checklists/](01%20checklists/)**: Contains best practice checklists tailored for different teams to ensure a successful evaluation, adoption, and rollout of Gemini Code Assist.
  - [`GCA_AppDev_Team_Checklist.md`](01%20checklists/GCA_AppDev_Team_Checklist.md): Best practices for Application Development teams.
  - [`GCA_Infosec_Team_Checklist.md`](01%20checklists/GCA_Infosec_Team_Checklist.md): Best practices for Information Security teams.
- **[samples/](02%20samples/)**: A directory intended for sample projects, code snippets, and practical demonstrations of the tools.
  - [`sample-policies.toml`](02%20samples/sample-policies.toml): A set of example rules for the Gemini CLI policy engine. Copy this file to `~/.gemini/policies/` (macOS/Linux) or `$env:USERPROFILE\.gemini\policies\` (Windows) to enforce fine-grained control over local tools and Model Context Protocol (MCP) servers.
  - [`sample-settings.json`](02%20samples/sample-settings.json): An example configuration to register MCP servers with Gemini CLI. Copy this file's contents to `~/.gemini/settings.json` to connect external tools (like GitHub, SQLite) into the CLI experience.
- **[surveys/](03%20surveys/)**: Contains resources for collecting developer feedback regarding their experience with Gemini Code Assist.
  - [`developer-survey-questions.md`](03%20surveys/developer-survey-questions.md): A template for a quick Pull Request feedback form to understand the impact of Gemini Code Assist on code quality and time saved.
  - [`devsat-survey.yml`](03%20surveys/devsat-survey.yml): A GitHub Actions workflow for automating the delivery of the Developer Satisfaction (DevSat) survey on new Pull Requests.
  - [`how-to-guide.md`](03%20surveys/how-to-guide.md): A step-by-step guide for Organization Administrators on completely enforcing Developer Satisfaction Surveys via GitHub Actions Repository Rulesets.
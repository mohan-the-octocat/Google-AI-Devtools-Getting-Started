# Google AI Devtools Getting Started

This repository provides resources, guidelines, and samples for getting started with Google AI Developer Tools, specifically focusing on Gemini Code Assist (GCA).

## Constituents

- **`checklists/`**: Contains best practice checklists tailored for different teams to ensure a successful evaluation, adoption, and rollout of Gemini Code Assist.
  - `GCA_AppDev_Team_Checklist.md`: Best practices for Application Development teams.
  - `GCA_Infosec_Team_Checklist.md`: Best practices for Information Security teams.
- **`samples/`**: A directory intended for sample projects, code snippets, and practical demonstrations of the tools.
  - `sample-policies.toml`: A set of example rules for the Gemini CLI policy engine. Copy this file to `~/.gemini/policies/` (macOS/Linux) or `$env:USERPROFILE\.gemini\policies\` (Windows) to enforce fine-grained control over local tools and Model Context Protocol (MCP) servers.
  - `sample-settings.json`: An example configuration to register MCP servers with Gemini CLI. Copy this file's contents to `~/.gemini/settings.json` to connect external tools (like GitHub, SQLite) into the CLI experience.
# Gemini Code Assist Observability & Telemetry Best Practices

This repository serves as a guide for configuring observability, monitoring, and telemetry for **Gemini Code Assist**. It covers custom Log Analytics (LQL) queries, Cloud Monitoring metrics configuration, quotas, and user-level identity logging configurations.

---

## 📋 Topics Covered

These standard telemetry practices enable platform administrators to answer key questions beyond the standard out-of-the-box overview dashboards:

1. **Active Users**: Track day-wise active user count over custom durations (30, 60, 90 days).
2. **User Identity Auditing**: Enable metadata logging to link telemetry to specific user principal emails for compliance.
3. **Lines of Code Accepted**: Track daily and YTD lines of accepted code using custom Metric Explorer configurations.
4. **Granular Telemetry**: Analyze which user accepted how many lines of code using LQL.
5. **Cumulative Acceptance Ratio**: Graph custom ratios in Metrics Explorer (Accepted Suggestions / Total Suggestions).
6. **Quota & Rate Limit Management**: Monitor and set custom threshold warnings for GCA API quotas.
7. **Advanced Log Analytics**: Query granular raw activity records using Log Analytics SQL to extract exact timestamps, user identities, client environments, API methods, and response payloads.

---

## 🚀 Getting Started

All configurations, queries, and detailed instructions are documented in the main reference file:

* 👉 **[Observability and Telemetry Guide](./gemini-code-assist-observability.md)**

---

## 🤝 Contributing

Contributions of new LQL queries, custom alerts, or dashboard setups are welcome. Please open an issue or pull request to add your telemetry configuration examples to this list.

# Gemini Code Assist Observability & Telemetry Reference Guide

To provide granular, user-level, and historical data beyond the standard Gemini Code Assist Overview dashboard, you can use these custom Log Analytics (LQL) queries, Cloud Logging configurations, and Metrics Explorer setups.

---

## 1. Day-wise Active User Count (Past 30, 60, 90 days)

The default "Overview" page shows rolling averages. Use this method to get a specific day-by-day active user count for longer durations:

* **Method**: Use the **Observability Monitoring > Dashboards - Gemini Code Assist Metrics**.
* **Time Range**: Customize the time range to 30, 60, or 90 days by setting the **Relative time** to `30d`, `60d`, or `90d`.
* **Link Example (30d)**: 
  [Gemini Code Assist Metrics Builder Console](https://console.cloud.google.com/monitoring/dashboards/builder/66914f46-7e82-4787-b32e-55b55221c048;duration=P30D;filters=var:client?project='Datamatics_project')

---

## 2. User Identities (Who logged on?)

For privacy and compliance reasons, individual user IDs are not shown in aggregated dashboards by default.

* **Solution**: Enable **Metadata Logging**.
* **How to Enable**: In the Google Cloud Console, navigate to **Admin for Gemini > Settings** and toggle **"Logging for Code Assist metadata"** to **ON**.
* **Result**: Once enabled, Cloud Logging will capture the `user_id` for every interaction, allowing you to trace active users.
* **Example LQL (active user emails in past 30 days)**:
  ```query
  protoPayload.authenticationInfo.principalEmail:*
  timestamp >= "2026-04-07T00:00:00Z"
  ```

---

## 3. Daily Lines of Code Accepted (Absolute Numbers / YTD)

The default "Overview" page shows rolling averages. To track specific day-by-day counts for longer durations or Year-To-Date (YTD):

* **Method**: Navigate to **Cloud Monitoring > Metrics Explorer**.
* **Metric**: Search for `cloudaicompanion.googleapis.com/code_assist/code_lines_accepted_count`.
* **Aggregation & Setup**: Customize the time range to 30, 60, or 90 days (or a custom date range starting Jan 1st for YTD) and set the **Aggregation** to **Sum** to see the exact absolute historical trend. Choosing a custom date range and a "Sum" aligner displays the total volume of code accepted rather than just a daily snapshot.

---

## 4. User-wise Telemetry (Who accepted which lines?)

* **Solution**: This is supported via the **Metadata Logging** enabled in Step 2.
* **Data Available**: Each log entry contains both the `user_id` and the `code_acceptance.lines_count`.
* **Example LQL (to view individual acceptance logs)**:
  ```query
  resource.type="cloudaicompanion.googleapis.com/Instance"
  jsonPayload.chatAcceptance.linesCount:*
  ```

---

## 5. Cumulative Acceptance Ratio

The standard "Acceptance Rate" is calculated as:
$$\text{Acceptance Rate} = \frac{\text{Accepted Suggestions}}{\text{Total Suggestions Shown}}$$

* **Method**: Build a ratio query in **Monitoring > Metrics Explorer**.
* **Configuration Steps**:
  1. Select the metric: `code_suggestions_accepted_count`.
  2. Click **"+ Add Query"** to add a second metric: `code_suggestions_count`.
  3. Click the **"Create Ratio"** tab that appears at the top of the query builder. This will automatically divide the two values and display the percentage on the graph.

---

## 6. API Quotas and Custom Limits

* **Quota**: The rate limits set by Google to ensure service stability. For Gemini Code Assist Enterprise, this is typically **2,000 requests per user per day**.
* **Custom Limits**: Thresholds you can configure within the **Google Cloud Quotas & Limits** page. They allow you to proactively manage usage and prevent unexpected billing spikes if you are on a usage-based plan.
* **Analysis**: Tracking these metrics helps identify if any users are "hitting the ceiling" of their daily allowance, indicating intense usage (e.g., heavy refactoring) or a need for a higher tier allocation.

---

## 7. Advanced Log Analytics (Intricate User & Action Details)

To query granular, raw activity records containing exact timestamps, user identities, and action categories, use Cloud Logging Log Analytics.

* **Step 1**: In the Google Cloud Console, navigate to **Logging > Log Analytics**.
* **Step 2**: If prompted, switch to **Builder** mode (SQL query editor).
* **Step 3**: Paste the following SQL query. Make sure to replace `Project name` (the target log view path, typically formatted as `` `project-id.global._Required._AllLogs` `` or similar Log Analytics view name) and the timestamp parameter with your target project and time range:

```sql
WITH
  logs AS (
    SELECT
      *
    FROM
      `Project name`
  )
SELECT
  timestamp,
  labels.user_id,
  labels.client_name,
  labels.method,
  labels.product,
  receive_timestamp,
  log_id,
  log_name,
  labels,
  resource,  
  resource.labels.project_id,
  severity,
  text_payload,
  proto_payload,
  json_payload
FROM
  logs
WHERE
  (NORMALIZE_AND_CASEFOLD(logs.resource.type, NFKC) = "cloudaicompanion.googleapis.com/instance" AND NORMALIZE_AND_CASEFOLD(SAFE.STRING(logs.labels["product"]),
    NFKC) = "code_assist" AND (CONTAINS_SUBSTR(SAFE.STRING(logs.labels["method"]), "CompleteCode") OR CONTAINS_SUBSTR(SAFE.STRING(logs.labels["method"]),
    "Chat") OR CONTAINS_SUBSTR(SAFE.STRING(logs.labels["method"]), "GenerateCode")) AND logs.timestamp >=
  TIMESTAMP("2026-05-18T00:00:00+00:00"))
ORDER BY timestamp DESC, timestamp_unix_nanos DESC, insert_id DESC
LIMIT 1000
```

### Intricate Details Captured:
* **`timestamp`**: The exact UTC time when the user request occurred.
* **`labels.user_id`**: The unique identifier of the user executing the code assist interaction.
* **`labels.client_name`**: The IDE/editor client used (e.g., VS Code, Cloud Workstations, JetBrains).
* **`labels.method`**: The API action triggered (e.g., `CompleteCode`, `Chat`, or `GenerateCode`).
* **`labels.product`**: The AI product classification (filtering for `code_assist`).
* **`receive_timestamp`**: When the log entry arrived in Cloud Logging.
* **`log_id` / `log_name`**: Core cloud logging labels for record identification.
* **`labels`**: Map of all metadata labels associated with the log entry.
* **`resource`**: The monitored resource metadata.
* **`resource.labels.project_id`**: The Google Cloud project ID hosting the service.
* **`severity`**: Log entry severity level (e.g., `INFO`, `NOTICE`, `ERROR`).
* **`text_payload` / `proto_payload` / `json_payload`**: Detailed payloads representing full request/response schemas.


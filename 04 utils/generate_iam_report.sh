#!/bin/bash
set -euo pipefail

# ==============================================================================
# Script: generate_iam_report.sh
# Description: Generates a CSV listing IAM permissions for a GCP project.
#              Filters for named users only (excludes service accounts, groups, etc.)
#              and identifies whether permissions are direct or inherited.
# Usage: ./generate_iam_report.sh <PROJECT_ID>
# Requirements: gcloud CLI, jq
# ==============================================================================

PROJECT_ID=${1:-""}

# 1. Validation
if [ -z "$PROJECT_ID" ]; then
    echo "Usage: $0 <PROJECT_ID>"
    exit 1
fi

if ! command -v jq &> /dev/null; then
    echo "Error: 'jq' is not installed."
    exit 1
fi

if ! command -v gcloud &> /dev/null; then
    echo "Error: 'gcloud' CLI is not installed or not in PATH."
    exit 1
fi

OUTPUT_FILE="iam_report_${PROJECT_ID}.csv"

echo "Step 1/2: Fetching IAM policies from project hierarchy..."

# Fetch policies for project and all ancestors (folders/org)
POLICIES_JSON=$(gcloud projects get-ancestors-iam-policy "${PROJECT_ID}" --format=json)

echo "Step 2/2: Processing data and generating CSV (Users only)..."

# CSV Header
echo "User_Identity,Role,Inherited,Source_Type,Source_ID" > "${OUTPUT_FILE}"

# Parse JSON with jq
# - select(startswith("user:")) filters for named users only.
echo "${POLICIES_JSON}" | jq -r --arg pid "${PROJECT_ID}" '
  .[] | 
  .id as $id | 
  .type as $type | 
  ($id != $pid) as $is_inherited |
  .policy.bindings[]? | 
  .role as $role | 
  .members[] | 
  select(startswith("user:")) |
  [., $role, (if $is_inherited then "Yes" else "No" end), $type, $id] | @csv
' >> "${OUTPUT_FILE}"

echo "----------------------------------------------------------"
echo "Done! Report generated: ${OUTPUT_FILE}"
echo "Total user-role bindings found: $(($(wc -l < "${OUTPUT_FILE}") - 1))"
echo "----------------------------------------------------------"


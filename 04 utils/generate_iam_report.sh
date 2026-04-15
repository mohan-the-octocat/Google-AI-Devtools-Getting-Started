#!/bin/bash

# ==============================================================================
# Script: generate_iam_report.sh
# Description: Generates a CSV listing IAM permissions for a GCP project,
#              identifying whether permissions are direct or inherited.
# Usage: ./generate_iam_report.sh <PROJECT_ID>
# Requirements: gcloud CLI, jq
# ==============================================================================

PROJECT_ID=$1

# 1. Validation
if [ -z "$PROJECT_ID" ]; then
    echo "Usage: $0 <PROJECT_ID>"
    exit 1
fi

if ! command -v jq &> /dev/null; then
    echo "Error: 'jq' is not installed. Please install it (e.g., brew install jq or sudo apt-get install jq)."
    exit 1
fi

if ! command -v gcloud &> /dev/null; then
    echo "Error: 'gcloud' CLI is not installed or not in PATH."
    exit 1
fi

OUTPUT_FILE="iam_report_${PROJECT_ID}.csv"

echo "Step 1/2: Fetching IAM policies from project hierarchy..."

# Fetch policies for project and all ancestors (folders/org)
# get-ancestors-iam-policy returns a list of resources with their policies.
POLICIES_JSON=$(gcloud projects get-ancestors-iam-policy "${PROJECT_ID}" --format=json 2>/dev/null)

if [ $? -ne 0 ]; then
    echo "Error: Failed to retrieve IAM policies."
    echo "Ensure you have the 'resourcemanager.projects.getIamPolicy' permission on the project and its ancestors."
    exit 1
fi

echo "Step 2/2: Processing data and generating CSV..."

# CSV Header
echo "Identity,Role,Inherited,Source_Type,Source_ID" > "${OUTPUT_FILE}"

# Parse JSON with jq
# - Checks if the resource ID matches the requested PROJECT_ID to determine inheritance.
# - Flattens the bindings and members into rows.
echo "${POLICIES_JSON}" | jq -r --arg pid "${PROJECT_ID}" '
  .[] | 
  .id as $id | 
  .type as $type | 
  ($id != $pid) as $is_inherited |
  .policy.bindings[]? | 
  .role as $role | 
  .members[] | 
  [., $role, (if $is_inherited then "Yes" else "No" end), $type, $id] | @csv
' >> "${OUTPUT_FILE}"

echo "----------------------------------------------------------"
echo "Done! Report generated: ${OUTPUT_FILE}"
echo "Total bindings found: $(($(wc -l < "${OUTPUT_FILE}") - 1))"
echo "----------------------------------------------------------"

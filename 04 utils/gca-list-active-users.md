# List Active Users - Helper Script

## Steps to follow
### 1. Navigate to Google Cloud Console >> "Observability Analytics"
<img width="304" height="335" alt="image" src="https://github.com/user-attachments/assets/febb5471-770d-4b3e-8f43-1e3ef6d76fa7" />

### 2. Copy the query, update the Project ID and paste it in the "Query" tab
```
SELECT
    JSON_VALUE(labels.user_id) AS user_id,
    COUNT(DISTINCT JSON_VALUE(labels.prompt_id)) AS number_of_prompts
FROM
    `##INSERT-PROJECT-ID##.global._Default._Default`
WHERE
    JSON_VALUE(labels.user_id) IS NOT NULL
    AND JSON_VALUE(labels.prompt_id) IS NOT NULL
GROUP BY
    user_id
ORDER BY
    number_of_prompts DESC;
```
<img width="614" height="362" alt="image" src="https://github.com/user-attachments/assets/5fba2491-7745-4cb9-ba83-0ac0848d4380" />

### 3. Update the timeframe as required
<img width="637" height="305" alt="image" src="https://github.com/user-attachments/assets/52e8097e-31ea-4873-b75f-e6587fb602ea" />

### 4. Hit `Run Query` and once the table populates, download the results
<img width="1426" height="723" alt="image" src="https://github.com/user-attachments/assets/620a7a12-f85a-4c02-9ac0-988f05298c86" />

SELECT *
FROM flagged_transactions
WHERE severity = 'HIGH'
AND flagged_at::date = CURRENT_DATE;

SELECT
    t.account_id,
    COUNT(*) AS risk_count
FROM flagged_transactions f
JOIN transactions t
ON f.transaction_id = t.transaction_id
GROUP BY t.account_id
ORDER BY risk_count DESC;

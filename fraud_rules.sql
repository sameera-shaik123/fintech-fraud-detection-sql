-- High value transaction anomaly
WITH avg_txn AS (
    SELECT
        account_id,
        AVG(amount) AS avg_amount
    FROM transactions
    GROUP BY account_id
)
SELECT
    t.transaction_id,
    t.amount,
    a.avg_amount,
    'HIGH_VALUE_TRANSACTION' AS risk_reason
FROM transactions t
JOIN avg_txn a ON t.account_id = a.account_id
WHERE t.amount > 3 * a.avg_amount;

-- High risk merchant
SELECT
    t.transaction_id,
    m.merchant_name,
    m.risk_level,
    'HIGH_RISK_MERCHANT' AS risk_reason
FROM transactions t
JOIN merchants m ON t.merchant_id = m.merchant_id
WHERE m.risk_level = 'HIGH';

-- Rapid transactions
SELECT
    account_id,
    COUNT(*) AS txn_count,
    'RAPID_TRANSACTIONS' AS risk_reason
FROM transactions
WHERE transaction_time > NOW() - INTERVAL '10 minutes'
GROUP BY account_id
HAVING COUNT(*) > 1;

-- Insert high risk merchant transactions
INSERT INTO flagged_transactions (transaction_id, risk_reason)
SELECT
    t.transaction_id,
    'HIGH_RISK_MERCHANT'
FROM transactions t
JOIN merchants m ON t.merchant_id = m.merchant_id
WHERE m.risk_level = 'HIGH';

-- Velocity fraud
WITH txn_window AS (
    SELECT
        transaction_id,
        account_id,
        transaction_time,
        COUNT(*) OVER (
            PARTITION BY account_id
            ORDER BY transaction_time
            RANGE BETWEEN INTERVAL '10 minutes' PRECEDING AND CURRENT ROW
        ) AS txn_count_10min
    FROM transactions
)
SELECT
    transaction_id,
    account_id,
    txn_count_10min,
    'VELOCITY_FRAUD' AS risk_reason
FROM txn_window
WHERE txn_count_10min > 2;

-- Behavioral anomaly
WITH user_avg AS (
    SELECT
        a.account_id,
        AVG(t.amount) AS avg_spend
    FROM accounts a
    JOIN transactions t ON a.account_id = t.account_id
    GROUP BY a.account_id
)
SELECT
    t.transaction_id,
    t.amount,
    ua.avg_spend,
    'BEHAVIOR_ANOMALY' AS risk_reason
FROM transactions t
JOIN user_avg ua ON t.account_id = ua.account_id
WHERE t.amount > 3 * ua.avg_spend;

-- Union of risk rules
WITH risk_union AS (
    SELECT
        t.transaction_id,
        'HIGH_RISK_MERCHANT' AS risk_reason
    FROM transactions t
    JOIN merchants m ON t.merchant_id = m.merchant_id
    WHERE m.risk_level = 'HIGH'

    UNION ALL

    SELECT
        t.transaction_id,
        'HIGH_VALUE_ANOMALY' AS risk_reason
    FROM transactions t
    JOIN (
        SELECT
            account_id,
            AVG(amount) AS avg_amt
        FROM transactions
        GROUP BY account_id
    ) a ON t.account_id = a.account_id
    WHERE t.amount > 3 * a.avg_amt
)
INSERT INTO flagged_transactions (transaction_id, risk_reason)
SELECT transaction_id, risk_reason
FROM risk_union;

-- Add severity column
ALTER TABLE flagged_transactions
ADD COLUMN severity VARCHAR(10);

UPDATE flagged_transactions
SET severity =
    CASE
        WHEN risk_reason = 'HIGH_RISK_MERCHANT' THEN 'HIGH'
        WHEN risk_reason = 'HIGH_VALUE_ANOMALY' THEN 'MEDIUM'
        ELSE 'LOW'
    END;

CREATE INDEX idx_transactions_account_time
ON transactions (account_id, transaction_time);

CREATE INDEX idx_transactions_amount
ON transactions (amount);

CREATE INDEX idx_merchants_risk
ON merchants (risk_level);

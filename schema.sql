CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100),
    email VARCHAR(100),
    kyc_status VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE accounts (
    account_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    balance NUMERIC(12,2),
    account_status VARCHAR(20)
);
CREATE TABLE merchants (
    merchant_id SERIAL PRIMARY KEY,
    merchant_name VARCHAR(100),
    risk_level VARCHAR(20)
);
CREATE TABLE transactions (
    transaction_id SERIAL PRIMARY KEY,
    account_id INT REFERENCES accounts(account_id),
    merchant_id INT REFERENCES merchants(merchant_id),
    amount NUMERIC(10,2),
    transaction_time TIMESTAMP,
    status VARCHAR(20)
);
CREATE TABLE flagged_transactions (
    transaction_id INT,
    risk_reason VARCHAR(100),
    flagged_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
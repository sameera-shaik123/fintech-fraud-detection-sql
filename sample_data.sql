INSERT INTO users (full_name, email, kyc_status)
VALUES
('Aman Kumar', 'aman@gmail.com', 'VERIFIED'),
('Riya Sharma', 'riya@gmail.com', 'VERIFIED'),
('Rahul Verma', 'rahul@gmail.com', 'PENDING');
INSERT INTO accounts (user_id, balance, account_status)
VALUES
(1, 50000, 'ACTIVE'),
(2, 30000, 'ACTIVE'),
(3, 15000, 'ACTIVE');
INSERT INTO merchants (merchant_name, risk_level)
VALUES
('Amazon', 'LOW'),
('Flipkart', 'LOW'),
('CryptoX', 'HIGH'),
('UnknownPay', 'HIGH');
INSERT INTO transactions (account_id, merchant_id, amount, transaction_time, status)
VALUES
(1, 1, 1200, NOW() - INTERVAL '2 days', 'SUCCESS'),
(1, 3, 15000, NOW() - INTERVAL '1 day', 'SUCCESS'),
(1, 3, 18000, NOW(), 'SUCCESS'),
(2, 4, 20000, NOW(), 'SUCCESS'),
(3, 2, 500, NOW(), 'SUCCESS');
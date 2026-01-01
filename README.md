# fintech-fraud-detection-sql
Rule-based Fintech Fraud Detection System built using PostgreSQL to identify high-risk transactions and accounts.
# Fintech Fraud Detection using SQL (PostgreSQL)

## Overview
Rule-based fraud detection system for fintech transactions using PostgreSQL.

## Problem Statement
Detect suspicious transactions using SQL before applying machine learning.

## Fraud Rules Implemented
- High-risk merchant detection
- High-value transaction anomaly
- Velocity fraud
- Behavioral anomaly
- Severity classification

## Tech Stack
- PostgreSQL
- pgAdmin 4
- SQL (CTEs, Window Functions, Indexing)

## Execution Order
1. schema.sql
2. sample_data.sql
3. fraud_rules.sql
4. risk_aggregation.sql
5. performance_indexes.sql

## Outcome
Accounts are ranked by risk count to prioritize fraud investigations.


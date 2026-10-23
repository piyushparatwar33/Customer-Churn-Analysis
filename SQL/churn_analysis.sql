```sql
-- Customer Churn Analysis
-- Database: PostgreSQL

-- 1. View sample data
SELECT *
FROM customer_churn
LIMIT 10;

-- 2. Total customers
SELECT COUNT(*) AS total_customers
FROM customer_churn;

-- 3. Churn distribution
SELECT
    "Churn",
    COUNT(*) AS customer_count
FROM customer_churn
GROUP BY "Churn";

-- 4. Overall churn rate
SELECT
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE "Churn" = 'Yes')
        / NULLIF(COUNT(*), 0),
        2
    ) AS churn_rate_percentage
FROM customer_churn;

-- 5. Churn by contract type
SELECT
    "Contract",
    COUNT(*) AS total_customers,
    COUNT(*) FILTER (WHERE "Churn" = 'Yes') AS churned_customers
FROM customer_churn
GROUP BY "Contract"
ORDER BY churned_customers DESC;

-- 6. Churn by internet service
SELECT
    "InternetService",
    COUNT(*) AS total_customers,
    COUNT(*) FILTER (WHERE "Churn" = 'Yes') AS churned_customers
FROM customer_churn
GROUP BY "InternetService";

-- 7. Average monthly charges by churn status
SELECT
    "Churn",
    ROUND(AVG("MonthlyCharges")::numeric, 2) AS avg_monthly_charges
FROM customer_churn
GROUP BY "Churn";

-- 8. Churn by payment method
SELECT
    "PaymentMethod",
    COUNT(*) AS total_customers,
    COUNT(*) FILTER (WHERE "Churn" = 'Yes') AS churned_customers
FROM customer_churn
GROUP BY "PaymentMethod"
ORDER BY churned_customers DESC;

-- 9. Churn by tenure group
SELECT
    CASE
        WHEN "tenure" <= 12 THEN '0-12 months'
        WHEN "tenure" <= 24 THEN '13-24 months'
        WHEN "tenure" <= 48 THEN '25-48 months'
        ELSE '49+ months'
    END AS tenure_group,
    COUNT(*) AS total_customers,
    COUNT(*) FILTER (WHERE "Churn" = 'Yes') AS churned_customers
FROM customer_churn
GROUP BY tenure_group
ORDER BY MIN("tenure");

-- 10. Churn rate by contract
SELECT
    "Contract",
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE "Churn" = 'Yes')
        / NULLIF(COUNT(*), 0),
        2
    ) AS churn_rate_percentage
FROM customer_churn
GROUP BY "Contract"
ORDER BY churn_rate_percentage DESC;
```

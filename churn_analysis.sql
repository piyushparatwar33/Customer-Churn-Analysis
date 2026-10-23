-- Customer Churn Analysis
-- PostgreSQL
-- After importing Dataset/Customer-Churn.csv, use a table named customer_churn.
-- If your import tool lowercases or changes column names, adjust quoted identifiers accordingly.

-- 1. Total customers
SELECT COUNT(*) AS total_customers
FROM customer_churn;

-- 2. Churn distribution
SELECT "Churn", COUNT(*) AS customer_count
FROM customer_churn
GROUP BY "Churn"
ORDER BY "Churn";

-- 3. Overall churn rate (%)
SELECT ROUND(
    100.0 * COUNT(*) FILTER (WHERE "Churn" = 'Yes') / NULLIF(COUNT(*), 0),
    2
) AS churn_rate_percentage
FROM customer_churn;

-- 4. Churn by contract
SELECT
    "Contract",
    COUNT(*) AS total_customers,
    COUNT(*) FILTER (WHERE "Churn" = 'Yes') AS churned_customers,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE "Churn" = 'Yes') / NULLIF(COUNT(*), 0),
        2
    ) AS churn_rate_percentage
FROM customer_churn
GROUP BY "Contract"
ORDER BY churn_rate_percentage DESC;

-- 5. Churn by internet service
SELECT
    "InternetService",
    COUNT(*) AS total_customers,
    COUNT(*) FILTER (WHERE "Churn" = 'Yes') AS churned_customers
FROM customer_churn
GROUP BY "InternetService"
ORDER BY churned_customers DESC;

-- 6. Average monthly charges by churn status
SELECT "Churn", ROUND(AVG("MonthlyCharges")::numeric, 2) AS avg_monthly_charges
FROM customer_churn
GROUP BY "Churn";

-- 7. Churn by payment method
SELECT
    "PaymentMethod",
    COUNT(*) AS total_customers,
    COUNT(*) FILTER (WHERE "Churn" = 'Yes') AS churned_customers,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE "Churn" = 'Yes') / NULLIF(COUNT(*), 0),
        2
    ) AS churn_rate_percentage
FROM customer_churn
GROUP BY "PaymentMethod"
ORDER BY churn_rate_percentage DESC;

-- 8. Churn by tenure group
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

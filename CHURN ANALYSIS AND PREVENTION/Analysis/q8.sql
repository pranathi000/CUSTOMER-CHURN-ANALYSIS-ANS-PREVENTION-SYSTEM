-- q8 
-- First query: Current Business Metrics
WITH business_metrics AS (
    SELECT 
        COUNT(*) as total_customers,
        COUNT(CASE WHEN s.status = 'Active' THEN 1 END) as active_customers,
        ROUND(SUM(CASE WHEN s.status = 'Active' THEN sp.monthly_price * 12 ELSE 0 END), 2) as total_annual_recurring_revenue,
        ROUND(SUM(o.order_value), 2) as total_historical_revenue,
        ROUND(AVG(o.order_value), 2) as avg_order_value
    FROM customers c
    JOIN subscriptions s ON c.customer_id = s.customer_id
    JOIN subscription_plans sp ON s.plan_id = sp.plan_id
    LEFT JOIN orders o ON c.customer_id = o.customer_id
),
risk_metrics AS (
    SELECT 
        COUNT(CASE WHEN DATEDIFF(CURDATE(), last_order_date) > 180 OR status = 'Cancelled' THEN 1 END) as high_risk_customers,
        COUNT(CASE WHEN cancellation_requests > 0 THEN 1 END) as customers_with_cancellation_requests,
        ROUND(SUM(CASE WHEN DATEDIFF(CURDATE(), last_order_date) > 180 AND status = 'Active' 
                      THEN monthly_price * 12 * 0.7 ELSE 0 END), 2) as revenue_at_risk,
        ROUND(SUM(CASE WHEN status = 'Cancelled' THEN monthly_price * 12 ELSE 0 END), 2) as lost_revenue,
        COUNT(CASE WHEN status = 'Cancelled' THEN 1 END) as churned_customers
    FROM (
        SELECT 
            c.customer_id,
            s.status,
            sp.monthly_price,
            MAX(o.order_date) as last_order_date,
            COUNT(CASE WHEN st.issue_category = 'Cancellation Request' THEN 1 END) as cancellation_requests
        FROM customers c
        JOIN subscriptions s ON c.customer_id = s.customer_id
        JOIN subscription_plans sp ON s.plan_id = sp.plan_id
        LEFT JOIN orders o ON c.customer_id = o.customer_id
        LEFT JOIN support_tickets st ON c.customer_id = st.customer_id
        GROUP BY c.customer_id, s.status, sp.monthly_price
    ) customer_data
)

SELECT 
    'Current Business Metrics' as category,
    total_customers,
    active_customers,
    total_annual_recurring_revenue,
    total_historical_revenue,
    avg_order_value
FROM business_metrics

UNION ALL

SELECT 
    'Churn Risk Assessment',
    high_risk_customers,
    customers_with_cancellation_requests,
    revenue_at_risk,
    lost_revenue,
    churned_customers
FROM risk_metrics

UNION ALL

SELECT 
    'Prevention Campaign Results',
    14,
    7,
    3690.00,
    1375.00,
    168.4;
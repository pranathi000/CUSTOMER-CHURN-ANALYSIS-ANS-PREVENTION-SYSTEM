-- Query 1: Customer Overview & Basic Metrics
SELECT 
    COUNT(*) as total_customers,
    COUNT(CASE WHEN s.status = 'Active' THEN 1 END) as active_customers,
    COUNT(CASE WHEN s.status = 'Cancelled' THEN 1 END) as cancelled_customers,
    COUNT(CASE WHEN s.status = 'Paused' THEN 1 END) as paused_customers,
    ROUND(COUNT(CASE WHEN s.status = 'Cancelled' THEN 1 END) * 100.0 / COUNT(*), 1) as churn_rate_percent
FROM customers c
JOIN subscriptions s ON c.customer_id = s.customer_id;
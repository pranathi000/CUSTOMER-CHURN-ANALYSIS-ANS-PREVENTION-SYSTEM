-- q2 Query 2: Customer Value Segmentation

SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    s.status,
    sp.plan_name,
    COUNT(o.order_id) as total_orders,
    ROUND(COALESCE(SUM(o.order_value), 0), 2) as total_spent,
    ROUND(COALESCE(AVG(o.order_value), 0), 2) as avg_order_value,
    CASE 
        WHEN COUNT(o.order_id) >= 5 AND SUM(o.order_value) >= 200 THEN 'High Value'
        WHEN COUNT(o.order_id) >= 2 AND SUM(o.order_value) >= 75 THEN 'Medium Value'
        ELSE 'Low Value'
    END as customer_value_segment
FROM customers c
JOIN subscriptions s ON c.customer_id = s.customer_id
JOIN subscription_plans sp ON s.plan_id = sp.plan_id
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, s.status, sp.plan_name
ORDER BY total_spent DESC;
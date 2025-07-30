--  q4
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    s.status,
    sp.plan_name,
    sp.monthly_price,
    ROUND(COALESCE(SUM(o.order_value), 0), 2) as total_spent,
    
    -- Calculate annual value
    CASE 
        WHEN s.status = 'Active' THEN sp.monthly_price * 12
        ELSE 0
    END as estimated_annual_value,
    
    -- Risk level for revenue calculation
    CASE 
        WHEN s.status = 'Cancelled' THEN 0
        WHEN (DATEDIFF(CURDATE(), MAX(o.order_date)) > 365 OR 
              COUNT(CASE WHEN st.issue_category = 'Cancellation Request' THEN 1 END) > 0) 
        THEN sp.monthly_price * 12 * 0.95  -- 95% likely to churn
        WHEN DATEDIFF(CURDATE(), MAX(o.order_date)) > 180 
        THEN sp.monthly_price * 12 * 0.70  -- 70% likely to churn
        WHEN DATEDIFF(CURDATE(), MAX(o.order_date)) > 90 
        THEN sp.monthly_price * 12 * 0.40  -- 40% likely to churn
        ELSE sp.monthly_price * 12 * 0.10  -- 10% likely to churn
    END as annual_revenue_at_risk,
    
    -- Customer value segment
    CASE 
        WHEN COUNT(o.order_id) >= 5 AND SUM(o.order_value) >= 200 THEN 'High Value'
        WHEN COUNT(o.order_id) >= 2 AND SUM(o.order_value) >= 75 THEN 'Medium Value'
        ELSE 'Low Value'
    END as customer_value_segment

FROM customers c
JOIN subscriptions s ON c.customer_id = s.customer_id
JOIN subscription_plans sp ON s.plan_id = sp.plan_id
LEFT JOIN orders o ON c.customer_id = o.customer_id
LEFT JOIN support_tickets st ON c.customer_id = st.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, s.status, sp.plan_name, sp.monthly_price
HAVING annual_revenue_at_risk > 0
ORDER BY annual_revenue_at_risk DESC;
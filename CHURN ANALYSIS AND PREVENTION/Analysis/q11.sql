-- Query 11: Real-Time Prevention Alerts (FIXED)
WITH customer_last_order AS (
    SELECT 
        c.customer_id,
        c.first_name,
        c.last_name,
        c.email,
        s.status,
        sp.monthly_price,
        MAX(o.order_date) as last_order_date
    FROM customers c
    JOIN subscriptions s ON c.customer_id = s.customer_id
    JOIN subscription_plans sp ON s.plan_id = sp.plan_id
    LEFT JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name, c.email, s.status, sp.monthly_price
)

SELECT 
    customer_id,
    first_name,
    last_name,
    email,
    status,
    CASE 
        WHEN DATEDIFF(CURDATE(), last_order_date) > 365 THEN 'URGENT: Customer inactive 1+ year'
        WHEN DATEDIFF(CURDATE(), last_order_date) > 180 THEN 'HIGH: Customer inactive 6+ months'
        WHEN DATEDIFF(CURDATE(), last_order_date) > 90 THEN 'MEDIUM: Customer inactive 3+ months'
        WHEN status = 'Paused' THEN 'URGENT: Reactivate paused subscription'
        ELSE 'LOW: Monitor customer'
    END as action_required,
    
    DATEDIFF(CURDATE(), last_order_date) as days_since_last_order,
    monthly_price * 12 as annual_value_to_save,
    
    CASE 
        WHEN DATEDIFF(CURDATE(), last_order_date) > 365 THEN 'Executive Retention Call'
        WHEN DATEDIFF(CURDATE(), last_order_date) > 180 THEN 'Personal Outreach + 30% Discount'
        WHEN DATEDIFF(CURDATE(), last_order_date) > 90 THEN 'Email Campaign + 20% Discount'
        WHEN status = 'Paused' THEN 'Re-engagement Campaign'
        ELSE 'Monitor Only'
    END as recommended_campaign

FROM customer_last_order
WHERE status IN ('Active', 'Paused')
  AND (DATEDIFF(CURDATE(), last_order_date) > 90 OR status = 'Paused')
ORDER BY 
    CASE 
        WHEN DATEDIFF(CURDATE(), last_order_date) > 365 OR status = 'Paused' THEN 1
        WHEN DATEDIFF(CURDATE(), last_order_date) > 180 THEN 2
        ELSE 3
    END,
    annual_value_to_save DESC;
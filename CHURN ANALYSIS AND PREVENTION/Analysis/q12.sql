--  q12
-- This calculates what campaigns should be run and their costs
WITH customer_last_order AS (
    SELECT 
        c.customer_id,
        c.first_name,
        c.last_name,
        s.status,
        sp.monthly_price,
        MAX(o.order_date) as last_order_date
    FROM customers c
    JOIN subscriptions s ON c.customer_id = s.customer_id
    JOIN subscription_plans sp ON s.plan_id = sp.plan_id
    LEFT JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name, s.status, sp.monthly_price
)

SELECT 
    customer_id,
    first_name,
    last_name,
    status,
    DATEDIFF(CURDATE(), last_order_date) as days_since_last_order,
    monthly_price * 12 as annual_customer_value,
    
    -- Campaign Assignment
    CASE 
        WHEN DATEDIFF(CURDATE(), last_order_date) > 365 THEN 'Executive Retention Call'
        WHEN DATEDIFF(CURDATE(), last_order_date) > 180 THEN 'Personal Outreach + 30% Discount'
        WHEN DATEDIFF(CURDATE(), last_order_date) > 90 THEN 'Email Campaign + 20% Discount'
        WHEN status = 'Paused' THEN 'Re-engagement Campaign'
        ELSE 'Monitor Only'
    END as campaign_type,
    
    -- Campaign Cost
    CASE 
        WHEN DATEDIFF(CURDATE(), last_order_date) > 365 THEN 200.00
        WHEN DATEDIFF(CURDATE(), last_order_date) > 180 THEN 150.00
        WHEN DATEDIFF(CURDATE(), last_order_date) > 90 THEN 75.00
        WHEN status = 'Paused' THEN 50.00
        ELSE 0.00
    END as campaign_cost,
    
    -- Expected Success Rate
    CASE 
        WHEN DATEDIFF(CURDATE(), last_order_date) > 365 THEN 60.0
        WHEN DATEDIFF(CURDATE(), last_order_date) > 180 THEN 45.0
        WHEN DATEDIFF(CURDATE(), last_order_date) > 90 THEN 30.0
        WHEN status = 'Paused' THEN 40.0
        ELSE 0.0
    END as expected_success_rate,
    
    -- Potential Revenue Saved
    CASE 
        WHEN DATEDIFF(CURDATE(), last_order_date) > 365 THEN (monthly_price * 12) * 0.60
        WHEN DATEDIFF(CURDATE(), last_order_date) > 180 THEN (monthly_price * 12) * 0.45
        WHEN DATEDIFF(CURDATE(), last_order_date) > 90 THEN (monthly_price * 12) * 0.30
        WHEN status = 'Paused' THEN (monthly_price * 12) * 0.40
        ELSE 0.0
    END as potential_revenue_saved

FROM customer_last_order
WHERE status IN ('Active', 'Paused')
  AND (DATEDIFF(CURDATE(), last_order_date) > 90 OR status = 'Paused')
ORDER BY potential_revenue_saved DESC;
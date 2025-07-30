-- q14
WITH customer_last_order AS (
    SELECT 
        c.customer_id,
        c.first_name,
        c.last_name,
        c.email,
        s.status,
        sp.plan_name,
        sp.monthly_price,
        MAX(o.order_date) as last_order_date
    FROM customers c
    JOIN subscriptions s ON c.customer_id = s.customer_id
    JOIN subscription_plans sp ON s.plan_id = sp.plan_id
    LEFT JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name, c.email, s.status, sp.plan_name, sp.monthly_price
)

SELECT 
    'TODAY\'S ACTION LIST' as priority,
    customer_id,
    first_name,
    last_name,
    email,
    plan_name,
    status,
    
    CASE 
        WHEN DATEDIFF(CURDATE(), last_order_date) > 365 THEN 'URGENT - Call within 2 hours'
        WHEN status = 'Paused' THEN 'URGENT - Call within 4 hours'
        WHEN DATEDIFF(CURDATE(), last_order_date) > 180 THEN 'HIGH - Call within 24 hours'
        WHEN DATEDIFF(CURDATE(), last_order_date) > 90 THEN 'MEDIUM - Send email today'
        ELSE 'LOW - Monitor'
    END as action_timeline,
    
    CASE 
        WHEN DATEDIFF(CURDATE(), last_order_date) > 365 THEN 'Executive Retention Call + 40% Discount'
        WHEN status = 'Paused' THEN 'Reactivation Call + Free Month'
        WHEN DATEDIFF(CURDATE(), last_order_date) > 180 THEN 'Personal Outreach + 30% Discount'
        WHEN DATEDIFF(CURDATE(), last_order_date) > 90 THEN 'Email Campaign + 20% Discount'
        ELSE 'Monitor Only'
    END as specific_action,
    
    DATEDIFF(CURDATE(), last_order_date) as days_inactive,
    CONCAT('$', monthly_price * 12) as annual_value_at_risk,
    
    -- Script/Template for action
    CASE 
        WHEN DATEDIFF(CURDATE(), last_order_date) > 365 THEN 
            CONCAT('Hi ', first_name, ', we miss you! We have a special 40% discount to welcome you back.')
        WHEN status = 'Paused' THEN 
            CONCAT('Hi ', first_name, ', ready to restart your subscription? We have a free month offer.')
        WHEN DATEDIFF(CURDATE(), last_order_date) > 180 THEN 
            CONCAT('Hi ', first_name, ', we have some exciting new products! 30% off your next order.')
        WHEN DATEDIFF(CURDATE(), last_order_date) > 90 THEN 
            CONCAT('Hi ', first_name, ', don\'t miss out! 20% discount expires soon.')
        ELSE 'No action needed'
    END as contact_script

FROM customer_last_order
WHERE status IN ('Active', 'Paused')
  AND (DATEDIFF(CURDATE(), last_order_date) > 90 OR status = 'Paused')
ORDER BY 
    CASE 
        WHEN DATEDIFF(CURDATE(), last_order_date) > 365 OR status = 'Paused' THEN 1
        WHEN DATEDIFF(CURDATE(), last_order_date) > 180 THEN 2
        WHEN DATEDIFF(CURDATE(), last_order_date) > 90 THEN 3
        ELSE 4
    END,
    monthly_price DESC;
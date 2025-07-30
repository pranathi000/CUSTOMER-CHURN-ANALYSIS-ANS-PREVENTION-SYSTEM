-- q13
WITH customer_last_order AS (
    SELECT 
        c.customer_id,
        s.status,
        sp.monthly_price,
        MAX(o.order_date) as last_order_date
    FROM customers c
    JOIN subscriptions s ON c.customer_id = s.customer_id
    JOIN subscription_plans sp ON s.plan_id = sp.plan_id
    LEFT JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, s.status, sp.monthly_price
),
campaign_plan AS (
    SELECT 
        CASE 
            WHEN DATEDIFF(CURDATE(), last_order_date) > 365 THEN 'Executive Retention Call'
            WHEN DATEDIFF(CURDATE(), last_order_date) > 180 THEN 'Personal Outreach + 30% Discount'
            WHEN DATEDIFF(CURDATE(), last_order_date) > 90 THEN 'Email Campaign + 20% Discount'
            WHEN status = 'Paused' THEN 'Re-engagement Campaign'
            ELSE 'Monitor Only'
        END as campaign_type,
        
        CASE 
            WHEN DATEDIFF(CURDATE(), last_order_date) > 365 THEN 200.00
            WHEN DATEDIFF(CURDATE(), last_order_date) > 180 THEN 150.00
            WHEN DATEDIFF(CURDATE(), last_order_date) > 90 THEN 75.00
            WHEN status = 'Paused' THEN 50.00
            ELSE 0.00
        END as campaign_cost,
        
        CASE 
            WHEN DATEDIFF(CURDATE(), last_order_date) > 365 THEN 60.0
            WHEN DATEDIFF(CURDATE(), last_order_date) > 180 THEN 45.0
            WHEN DATEDIFF(CURDATE(), last_order_date) > 90 THEN 30.0
            WHEN status = 'Paused' THEN 40.0
            ELSE 0.0
        END as expected_success_rate,
        
        monthly_price * 12 as annual_customer_value
        
    FROM customer_last_order
    WHERE status IN ('Active', 'Paused')
      AND (DATEDIFF(CURDATE(), last_order_date) > 90 OR status = 'Paused')
)

SELECT 
    campaign_type,
    COUNT(*) as customers_targeted,
    ROUND(COUNT(*) * AVG(expected_success_rate) / 100, 0) as expected_retentions,
    SUM(campaign_cost) as total_campaign_cost,
    ROUND(SUM(annual_customer_value * expected_success_rate / 100), 2) as expected_revenue_saved,
    ROUND((SUM(annual_customer_value * expected_success_rate / 100) - SUM(campaign_cost)), 2) as expected_net_profit,
    ROUND((SUM(annual_customer_value * expected_success_rate / 100) - SUM(campaign_cost)) * 100.0 / SUM(campaign_cost), 1) as expected_roi_percent

FROM campaign_plan
WHERE campaign_type != 'Monitor Only'
GROUP BY campaign_type
ORDER BY expected_roi_percent DESC;
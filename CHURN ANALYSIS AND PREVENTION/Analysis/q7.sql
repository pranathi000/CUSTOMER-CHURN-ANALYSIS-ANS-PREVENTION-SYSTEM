-- q7
WITH campaign_simulation AS (
    SELECT 'Executive Retention Call' as intervention_type, 3 as customers_targeted, 2 as successful_retentions, 1500.00 as revenue_saved, 600.00 as total_cost
    UNION ALL
    SELECT 'Personal Outreach + 30% Discount', 2, 1, 900.00, 300.00
    UNION ALL  
    SELECT 'Email Campaign + 20% Discount', 4, 1, 300.00, 300.00
    UNION ALL
    SELECT 'Satisfaction Survey + Usage Tips', 3, 2, 450.00, 75.00
    UNION ALL
    SELECT 'Re-engagement Campaign', 2, 1, 540.00, 100.00
)
SELECT 
    intervention_type,
    customers_targeted,
    successful_retentions,
    (customers_targeted - successful_retentions) as customers_lost,
    ROUND(successful_retentions * 100.0 / customers_targeted, 1) as success_rate_percent,
    revenue_saved,
    total_cost,
    ROUND(revenue_saved - total_cost, 2) as net_profit,
    ROUND((revenue_saved - total_cost) * 100.0 / total_cost, 1) as roi_percent
FROM campaign_simulation

UNION ALL

SELECT 
    'TOTAL CAMPAIGNS' as intervention_type,
    SUM(customers_targeted),
    SUM(successful_retentions),
    SUM(customers_targeted - successful_retentions),
    ROUND(SUM(successful_retentions) * 100.0 / SUM(customers_targeted), 1),
    SUM(revenue_saved),
    SUM(total_cost),
    ROUND(SUM(revenue_saved) - SUM(total_cost), 2),
    ROUND((SUM(revenue_saved) - SUM(total_cost)) * 100.0 / SUM(total_cost), 1)
FROM campaign_simulation

ORDER BY 
    CASE intervention_type 
        WHEN 'TOTAL CAMPAIGNS' THEN 2 
        ELSE 1 
    END,
    roi_percent DESC;
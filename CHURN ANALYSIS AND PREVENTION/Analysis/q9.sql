--  q9
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    s.status,
    
    -- Order Activity
    COUNT(o.order_id) as total_orders,
    ROUND(COALESCE(SUM(o.order_value), 0), 2) as total_spent,
    MAX(o.order_date) as last_order_date,
    DATEDIFF(CURDATE(), MAX(o.order_date)) as days_since_last_order,
    
    -- Login Activity  
    COUNT(DISTINCT la.login_date) as total_login_days,
    MAX(la.login_date) as last_login_date,
    COALESCE(DATEDIFF(CURDATE(), MAX(la.login_date)), 999) as days_since_last_login,
    
    -- Engagement Score (0-100)
    ROUND(
        CASE 
            WHEN COUNT(DISTINCT la.login_date) = 0 THEN 0
            ELSE (
                -- Recent activity (50%)
                (CASE 
                    WHEN DATEDIFF(CURDATE(), MAX(la.login_date)) <= 7 THEN 50
                    WHEN DATEDIFF(CURDATE(), MAX(la.login_date)) <= 30 THEN 30
                    WHEN DATEDIFF(CURDATE(), MAX(la.login_date)) <= 90 THEN 15
                    ELSE 0
                END) +
                -- Login frequency (30%)
                (LEAST(COUNT(DISTINCT la.login_date) * 3, 30)) +
                -- Purchase activity (20%)
                (CASE 
                    WHEN DATEDIFF(CURDATE(), MAX(o.order_date)) <= 30 THEN 20
                    WHEN DATEDIFF(CURDATE(), MAX(o.order_date)) <= 90 THEN 10
                    ELSE 0
                END)
            )
        END, 0
    ) as engagement_score,
    
    -- Engagement Category
    CASE 
        WHEN COUNT(DISTINCT la.login_date) = 0 OR DATEDIFF(CURDATE(), MAX(la.login_date)) > 90 THEN 'Disengaged'
        WHEN DATEDIFF(CURDATE(), MAX(la.login_date)) <= 7 AND COUNT(o.order_id) >= 2 THEN 'Highly Engaged'
        WHEN DATEDIFF(CURDATE(), MAX(la.login_date)) <= 30 THEN 'Moderately Engaged'
        ELSE 'Low Engagement'
    END as engagement_category

FROM customers c
JOIN subscriptions s ON c.customer_id = s.customer_id
LEFT JOIN orders o ON c.customer_id = o.customer_id
LEFT JOIN login_activity la ON c.customer_id = la.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, s.status
ORDER BY engagement_score DESC, total_spent DESC;
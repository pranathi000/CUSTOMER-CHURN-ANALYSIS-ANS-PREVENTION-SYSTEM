WITH customer_satisfaction AS (
    SELECT 
        c.customer_id,
        s.status,
        COALESCE(AVG(st.customer_satisfaction_score), 0) as avg_satisfaction,
        COUNT(CASE WHEN st.issue_category = 'Cancellation Request' THEN 1 END) as cancellation_requests
    FROM customers c
    JOIN subscriptions s ON c.customer_id = s.customer_id
    LEFT JOIN support_tickets st ON c.customer_id = st.customer_id
    GROUP BY c.customer_id, s.status
)

SELECT 
    CASE 
        WHEN avg_satisfaction >= 4.5 THEN 'Excellent (4.5+)'
        WHEN avg_satisfaction >= 4.0 THEN 'Good (4.0-4.4)'
        WHEN avg_satisfaction >= 3.0 THEN 'Average (3.0-3.9)'
        WHEN avg_satisfaction >= 1.0 THEN 'Poor (1.0-2.9)'
        ELSE 'No Support History'
    END as satisfaction_level,
    
    COUNT(*) as customer_count,
    COUNT(CASE WHEN status = 'Cancelled' THEN 1 END) as churned_customers,
    ROUND(COUNT(CASE WHEN status = 'Cancelled' THEN 1 END) * 100.0 / COUNT(*), 1) as churn_rate_percent,
    ROUND(AVG(avg_satisfaction), 2) as avg_satisfaction_score,
    SUM(cancellation_requests) as total_cancellation_requests

FROM customer_satisfaction
GROUP BY 
    CASE 
        WHEN avg_satisfaction >= 4.5 THEN 'Excellent (4.5+)'
        WHEN avg_satisfaction >= 4.0 THEN 'Good (4.0-4.4)'
        WHEN avg_satisfaction >= 3.0 THEN 'Average (3.0-3.9)'
        WHEN avg_satisfaction >= 1.0 THEN 'Poor (1.0-2.9)'
        ELSE 'No Support History'
    END
ORDER BY churn_rate_percent DESC;
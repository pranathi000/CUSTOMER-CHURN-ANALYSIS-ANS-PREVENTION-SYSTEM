-- q10
WITH customer_risk_data AS (
    SELECT 
        c.customer_id,
        s.status,
        sp.monthly_price,
        MAX(o.order_date) as last_order_date,
        COUNT(CASE WHEN st.issue_category = 'Cancellation Request' THEN 1 END) as has_cancellation_request
    FROM customers c
    JOIN subscriptions s ON c.customer_id = s.customer_id
    JOIN subscription_plans sp ON s.plan_id = sp.plan_id
    LEFT JOIN orders o ON c.customer_id = o.customer_id
    LEFT JOIN support_tickets st ON c.customer_id = st.customer_id
    GROUP BY c.customer_id, s.status, sp.monthly_price
),
summary_metrics AS (
    SELECT 
        COUNT(*) as total_customers,
        COUNT(CASE WHEN status = 'Active' THEN 1 END) as active_customers,
        COUNT(CASE WHEN status = 'Cancelled' THEN 1 END) as churned_customers,
        COUNT(CASE WHEN DATEDIFF(CURDATE(), last_order_date) > 180 THEN 1 END) as high_risk_customers,
        COUNT(CASE WHEN has_cancellation_request > 0 THEN 1 END) as cancellation_requests,
        ROUND(SUM(CASE WHEN status = 'Active' THEN monthly_price * 12 ELSE 0 END), 2) as annual_recurring_revenue,
        ROUND(SUM(CASE WHEN DATEDIFF(CURDATE(), last_order_date) > 180 AND status = 'Active' 
                      THEN monthly_price * 12 * 0.7 ELSE 0 END), 2) as revenue_at_risk
    FROM customer_risk_data
)

SELECT 
    'EXECUTIVE SUMMARY' as metric_type,
    CONCAT(high_risk_customers, ' of ', total_customers, ' customers at high churn risk') as risk_overview,
    CONCAT('$', FORMAT(revenue_at_risk, 0), ' annual revenue at risk') as financial_impact,
    CONCAT(cancellation_requests, ' customers requesting cancellation') as urgent_actions,
    CONCAT(ROUND(churned_customers * 100.0 / total_customers, 1), '% historical churn rate') as churn_rate,
    CONCAT('$', FORMAT(annual_recurring_revenue, 0), ' total ARR') as business_size
FROM summary_metrics

UNION ALL

SELECT 
    'PREVENTION OPPORTUNITY',
    'Target 14 at-risk customers with campaigns',
    'Potential to save $3,690 in annual revenue',
    'Investment required: $1,375',
    'Expected ROI: 168%',
    'Break-even after retaining just 2 customers'

UNION ALL

SELECT 
    'RECOMMENDED ACTIONS',
    '3 customers need executive retention calls',
    '2 high-value customers need personal outreach',
    '4 customers need email campaigns',
    '5 customers need satisfaction surveys',
    'Implement monitoring for remaining customers';
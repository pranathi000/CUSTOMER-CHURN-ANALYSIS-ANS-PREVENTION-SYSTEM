-- q6
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    s.status,
    
    -- Risk Assessment
    DATEDIFF(CURDATE(), MAX(o.order_date)) as days_since_last_order,
    COUNT(st.ticket_id) as total_support_tickets,
    SUM(CASE WHEN st.issue_category = 'Cancellation Request' THEN 1 ELSE 0 END) as cancellation_requests,
    ROUND(COALESCE(SUM(o.order_value), 0), 2) as total_spent,
    
    -- Intervention Assignment
    CASE 
        WHEN SUM(CASE WHEN st.issue_category = 'Cancellation Request' THEN 1 ELSE 0 END) > 0 
        THEN 'Executive Retention Call'
        
        WHEN DATEDIFF(CURDATE(), MAX(o.order_date)) > 365 AND SUM(o.order_value) > 200 
        THEN 'Personal Outreach + 30% Discount'
        
        WHEN DATEDIFF(CURDATE(), MAX(o.order_date)) > 180 
        THEN 'Email Campaign + 20% Discount'
        
        WHEN DATEDIFF(CURDATE(), MAX(o.order_date)) > 90 
        THEN 'Satisfaction Survey + Usage Tips'
        
        WHEN s.status = 'Paused' 
        THEN 'Re-engagement Campaign'
        
        ELSE 'Monitor Only'
    END as intervention_type,
    
    -- Estimated Campaign Cost
    CASE 
        WHEN SUM(CASE WHEN st.issue_category = 'Cancellation Request' THEN 1 ELSE 0 END) > 0 THEN 200.00
        WHEN DATEDIFF(CURDATE(), MAX(o.order_date)) > 365 AND SUM(o.order_value) > 200 THEN 150.00
        WHEN DATEDIFF(CURDATE(), MAX(o.order_date)) > 180 THEN 75.00
        WHEN DATEDIFF(CURDATE(), MAX(o.order_date)) > 90 THEN 25.00
        WHEN s.status = 'Paused' THEN 50.00
        ELSE 0.00
    END as estimated_campaign_cost,
    
    -- Priority Level
    CASE 
        WHEN SUM(CASE WHEN st.issue_category = 'Cancellation Request' THEN 1 ELSE 0 END) > 0 THEN 'URGENT'
        WHEN DATEDIFF(CURDATE(), MAX(o.order_date)) > 365 THEN 'HIGH'
        WHEN DATEDIFF(CURDATE(), MAX(o.order_date)) > 180 THEN 'MEDIUM'
        ELSE 'LOW'
    END as priority_level

FROM customers c
JOIN subscriptions s ON c.customer_id = s.customer_id
LEFT JOIN orders o ON c.customer_id = o.customer_id
LEFT JOIN support_tickets st ON c.customer_id = st.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, s.status
HAVING intervention_type != 'Monitor Only'
ORDER BY 
    CASE priority_level 
        WHEN 'URGENT' THEN 1 
        WHEN 'HIGH' THEN 2 
        WHEN 'MEDIUM' THEN 3 
        ELSE 4 
    END,
    total_spent DESC;
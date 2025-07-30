-- query 3

SELECT customer_id, first_name, last_name, cancellation_requests, total_risk_score, risk_category 
FROM (
    -- Your complete Q3 query here
    SELECT 
        c.customer_id,
        c.first_name,
        c.last_name,
        s.status,
        COUNT(o.order_id) as total_orders,
        MAX(o.order_date) as last_order_date,
        DATEDIFF(CURDATE(), MAX(o.order_date)) as days_since_last_order,
        
        CASE 
            WHEN DATEDIFF(CURDATE(), MAX(o.order_date)) > 365 OR MAX(o.order_date) IS NULL THEN 100
            WHEN DATEDIFF(CURDATE(), MAX(o.order_date)) > 180 THEN 80
            WHEN DATEDIFF(CURDATE(), MAX(o.order_date)) > 90 THEN 60
            WHEN DATEDIFF(CURDATE(), MAX(o.order_date)) > 30 THEN 40
            ELSE 20
        END as recency_risk_score,
        
        COUNT(st.ticket_id) as total_support_tickets,
        SUM(CASE WHEN st.issue_category = 'Cancellation Request' THEN 1 ELSE 0 END) as cancellation_requests,
        CASE 
            WHEN SUM(CASE WHEN st.issue_category = 'Cancellation Request' THEN 1 ELSE 0 END) > 0 THEN 50
            WHEN COUNT(st.ticket_id) >= 3 THEN 30
            WHEN COUNT(st.ticket_id) >= 1 THEN 15
            ELSE 0
        END as support_risk_score,
        
        (CASE 
            WHEN DATEDIFF(CURDATE(), MAX(o.order_date)) > 365 OR MAX(o.order_date) IS NULL THEN 100
            WHEN DATEDIFF(CURDATE(), MAX(o.order_date)) > 180 THEN 80
            WHEN DATEDIFF(CURDATE(), MAX(o.order_date)) > 90 THEN 60
            WHEN DATEDIFF(CURDATE(), MAX(o.order_date)) > 30 THEN 40
            ELSE 20
        END) +
        (CASE 
            WHEN SUM(CASE WHEN st.issue_category = 'Cancellation Request' THEN 1 ELSE 0 END) > 0 THEN 50
            WHEN COUNT(st.ticket_id) >= 3 THEN 30
            WHEN COUNT(st.ticket_id) >= 1 THEN 15
            ELSE 0
        END) as total_risk_score,
        
        CASE 
            WHEN s.status = 'Cancelled' THEN 'Already Churned'
            WHEN (DATEDIFF(CURDATE(), MAX(o.order_date)) > 365 OR 
                  SUM(CASE WHEN st.issue_category = 'Cancellation Request' THEN 1 ELSE 0 END) > 0) THEN 'Critical Risk'
            WHEN DATEDIFF(CURDATE(), MAX(o.order_date)) > 180 THEN 'High Risk'
            WHEN DATEDIFF(CURDATE(), MAX(o.order_date)) > 90 THEN 'Medium Risk'
            ELSE 'Low Risk'
        END as risk_category
        
    FROM customers c
    JOIN subscriptions s ON c.customer_id = s.customer_id
    LEFT JOIN orders o ON c.customer_id = o.customer_id
    LEFT JOIN support_tickets st ON c.customer_id = st.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name, s.status
    ORDER BY total_risk_score DESC
) q3_data 
WHERE customer_id IN (2, 4);  -- Check Michael Chen and David Thompson
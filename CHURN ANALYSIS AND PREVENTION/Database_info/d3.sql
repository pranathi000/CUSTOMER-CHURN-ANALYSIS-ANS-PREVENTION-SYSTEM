-- Insert orders (varying patterns for different customers)
INSERT INTO orders VALUES
-- Sarah Johnson (High Value - Regular orders)
(1, 1, '2023-01-15', 47.50, 'Completed'),
(2, 1, '2023-02-18', 52.30, 'Completed'),
(3, 1, '2023-03-22', 48.75, 'Completed'),
(4, 1, '2023-04-25', 51.20, 'Completed'),
(5, 1, '2023-05-28', 49.80, 'Completed'),
(6, 1, '2023-07-02', 53.40, 'Completed'),
(7, 1, '2023-08-05', 46.90, 'Completed'),

-- Michael Chen (High spend but stopped ordering - CHURN RISK!)
(8, 2, '2023-02-20', 85.60, 'Completed'),
(9, 2, '2023-03-25', 92.40, 'Completed'),
(10, 2, '2023-04-30', 88.70, 'Completed'),
-- No orders since April 2023 - 760+ days gap!

-- Jessica Williams (Irregular pattern - CHURN RISK!)
(11, 3, '2023-03-10', 67.20, 'Completed'),
(12, 3, '2023-05-15', 71.80, 'Completed'),
-- Long gap, then one order
(13, 3, '2023-12-20', 65.50, 'Completed'),

-- David Thompson (Cancelled - stopped ordering)
(14, 4, '2023-01-25', 78.90, 'Completed'),
(15, 4, '2023-02-28', 82.15, 'Completed'),
-- No orders after cancellation

-- Emily Davis (Low activity)
(16, 5, '2023-04-05', 28.40, 'Completed'),
(17, 5, '2023-06-12', 31.75, 'Completed'),

-- Ryan Brown (Good customer but recent gap)
(18, 6, '2023-02-14', 58.30, 'Completed'),
(19, 6, '2023-03-20', 62.85, 'Completed'),
(20, 6, '2023-04-25', 59.70, 'Completed'),
(21, 6, '2023-05-30', 61.45, 'Completed'),

-- Amanda Miller (New customer, good start)
(22, 7, '2023-05-12', 34.60, 'Completed'),
(23, 7, '2023-06-15', 37.20, 'Completed'),
(24, 7, '2023-07-18', 35.85, 'Completed'),

-- Continue for remaining customers...
(25, 8, '2023-03-28', 55.40, 'Completed'),
(26, 8, '2023-05-02', 59.75, 'Completed'),

(27, 9, '2023-01-08', 95.20, 'Completed'),
(28, 9, '2023-02-12', 87.65, 'Completed'),
(29, 9, '2023-03-18', 91.30, 'Completed'),
(30, 9, '2023-04-22', 89.85, 'Completed'),
(31, 9, '2023-05-26', 93.40, 'Completed'),
(32, 9, '2023-06-30', 88.90, 'Completed'),

(33, 10, '2023-04-18', 42.30, 'Completed'),
(34, 10, '2023-05-22', 38.75, 'Completed'),
(35, 10, '2023-06-25', 41.60, 'Completed'),

-- Add more orders for remaining customers
(36, 12, '2023-05-25', 33.80, 'Completed'),
(37, 13, '2023-03-15', 79.50, 'Completed'),
(38, 13, '2023-04-20', 82.30, 'Completed'),
(39, 15, '2023-04-22', 29.90, 'Completed'),
(40, 16, '2023-02-28', 84.70, 'Completed'),
(41, 16, '2023-04-05', 88.20, 'Completed'),
(42, 18, '2023-03-20', 56.40, 'Completed'),
(43, 19, '2023-01-12', 91.75, 'Completed'),
(44, 19, '2023-02-16', 89.30, 'Completed'),
(45, 20, '2023-04-30', 27.85, 'Completed');
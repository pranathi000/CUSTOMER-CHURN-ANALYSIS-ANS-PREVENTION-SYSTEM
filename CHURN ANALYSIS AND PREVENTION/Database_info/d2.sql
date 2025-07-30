-- Insert subscription plans
INSERT INTO subscription_plans VALUES
(1, 'Starter Box', 25.00, 'Basic monthly subscription'),
(2, 'Family Pack', 45.00, 'Family size monthly box'),
(3, 'Premium Deluxe', 75.00, 'Premium monthly subscription');

-- Insert customers
INSERT INTO customers VALUES
(1, 'Sarah', 'Johnson', 'sarah.j@email.com', '2023-01-15', '555-0101'),
(2, 'Michael', 'Chen', 'michael.c@email.com', '2023-02-20', '555-0102'),
(3, 'Jessica', 'Williams', 'jessica.w@email.com', '2023-03-10', '555-0103'),
(4, 'David', 'Thompson', 'david.t@email.com', '2023-01-25', '555-0104'),
(5, 'Emily', 'Davis', 'emily.d@email.com', '2023-04-05', '555-0105'),
(6, 'Ryan', 'Brown', 'ryan.b@email.com', '2023-02-14', '555-0106'),
(7, 'Amanda', 'Miller', 'amanda.m@email.com', '2023-05-12', '555-0107'),
(8, 'Kevin', 'Wilson', 'kevin.w@email.com', '2023-03-28', '555-0108'),
(9, 'Lisa', 'Garcia', 'lisa.g@email.com', '2023-01-08', '555-0109'),
(10, 'James', 'Martinez', 'james.m@email.com', '2023-04-18', '555-0110'),
(11, 'Nicole', 'Anderson', 'nicole.a@email.com', '2023-02-03', '555-0111'),
(12, 'Christopher', 'Taylor', 'chris.t@email.com', '2023-05-25', '555-0112'),
(13, 'Rachel', 'Thomas', 'rachel.t@email.com', '2023-03-15', '555-0113'),
(14, 'Daniel', 'Jackson', 'daniel.j@email.com', '2023-01-30', '555-0114'),
(15, 'Ashley', 'White', 'ashley.w@email.com', '2023-04-22', '555-0115'),
(16, 'Matthew', 'Harris', 'matthew.h@email.com', '2023-02-28', '555-0116'),
(17, 'Stephanie', 'Martin', 'stephanie.m@email.com', '2023-05-08', '555-0117'),
(18, 'Joshua', 'Lee', 'joshua.l@email.com', '2023-03-20', '555-0118'),
(19, 'Michelle', 'Clark', 'michelle.c@email.com', '2023-01-12', '555-0119'),
(20, 'Brandon', 'Lewis', 'brandon.l@email.com', '2023-04-30', '555-0120');

-- Insert subscriptions
INSERT INTO subscriptions VALUES
(1, 1, 1, 'Active', '2023-01-15', NULL),
(2, 2, 3, 'Cancelled', '2023-02-20', '2024-01-15'),
(3, 3, 2, 'Active', '2023-03-10', NULL),
(4, 4, 3, 'Cancelled', '2023-01-25', '2024-02-10'),
(5, 5, 1, 'Paused', '2023-04-05', NULL),
(6, 6, 2, 'Active', '2023-02-14', NULL),
(7, 7, 1, 'Active', '2023-05-12', NULL),
(8, 8, 2, 'Paused', '2023-03-28', NULL),
(9, 9, 3, 'Active', '2023-01-08', NULL),
(10, 10, 1, 'Active', '2023-04-18', NULL),
(11, 11, 2, 'Cancelled', '2023-02-03', '2024-03-01'),
(12, 12, 1, 'Active', '2023-05-25', NULL),
(13, 13, 3, 'Active', '2023-03-15', NULL),
(14, 14, 2, 'Paused', '2023-01-30', NULL),
(15, 15, 1, 'Active', '2023-04-22', NULL),
(16, 16, 3, 'Active', '2023-02-28', NULL),
(17, 17, 1, 'Cancelled', '2023-05-08', '2024-04-12'),
(18, 18, 2, 'Active', '2023-03-20', NULL),
(19, 19, 3, 'Active', '2023-01-12', NULL),
(20, 20, 1, 'Paused', '2023-04-30', NULL);
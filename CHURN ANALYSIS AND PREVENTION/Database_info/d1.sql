-- Create database
CREATE DATABASE churn_analytics;
USE churn_analytics;

-- Create customers table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    registration_date DATE,
    phone VARCHAR(20)
);

-- Create subscription plans table
CREATE TABLE subscription_plans (
    plan_id INT PRIMARY KEY,
    plan_name VARCHAR(50),
    monthly_price DECIMAL(10,2),
    description TEXT
);

-- Create subscriptions table
CREATE TABLE subscriptions (
    subscription_id INT PRIMARY KEY,
    customer_id INT,
    plan_id INT,
    status VARCHAR(20),
    start_date DATE,
    end_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (plan_id) REFERENCES subscription_plans(plan_id)
);

-- Create orders table
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    order_value DECIMAL(10,2),
    status VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Create support tickets table
CREATE TABLE support_tickets (
    ticket_id INT PRIMARY KEY,
    customer_id INT,
    ticket_date DATE,
    issue_category VARCHAR(50),
    priority VARCHAR(20),
    status VARCHAR(20),
    customer_satisfaction_score INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Create product reviews table
CREATE TABLE product_reviews (
    review_id INT PRIMARY KEY,
    customer_id INT,
    review_date DATE,
    rating INT,
    review_text TEXT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Create login activity table
CREATE TABLE login_activity (
    login_id INT PRIMARY KEY,
    customer_id INT,
    login_date DATE,
    session_duration_minutes INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
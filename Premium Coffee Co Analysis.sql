-- Premium Coffee Co Analysis
USE coffee_co;

SELECT * FROM city;
SELECT * FROM customers;
SELECT * FROM products;
SELECT * FROM sales;

-- Total Revenue
SELECT FORMAT(SUM(total), 2) AS total_revenue FROM sales;

-- Average Rating
SELECT ROUND(AVG(rating), 2) AS avg_rating FROM sales;

-- Top 3 cities with the highest number of customers
SELECT ci.city_name, COUNT(cu.customer_id) AS customer_count
FROM city AS ci INNER JOIN customers AS cu 
ON ci.city_id = cu.city_id
GROUP BY ci.city_name
ORDER BY customer_count DESC;

-- 16th March, 2026
-- Top 3 cities with the highest number of customers
SELECT 
	ci.city_name, 
    COUNT(cu.customer_id) AS customer_count,
    SUM(COUNT(cu.customer_id)) OVER() AS total_customers,
    CONCAT(ROUND(COUNT(cu.customer_id) * 100 / SUM(COUNT(cu.customer_id)) OVER(), 2), '%') AS percentage
FROM city AS ci INNER JOIN customers AS cu 
ON ci.city_id = cu.city_id
GROUP BY ci.city_name
ORDER BY customer_count DESC;

-- Top 5 products based on sales volume
SELECT 
	p.product_name, 
    COUNT(s.product_id) AS units_sold,
    FORMAT(SUM(COUNT(s.product_id)) OVER(), 0) AS total,
	CONCAT(ROUND(COUNT(s.product_id) * 100 / SUM(COUNT(s.product_id)) OVER(), 2), '%') AS percentage
FROM products AS p INNER JOIN sales AS s
ON p.product_id = s.product_id
GROUP BY p.product_name
ORDER BY units_sold DESC;

-- Products with average rating below 3
SELECT p.product_name, AVG(s.rating) AS avg_rating
FROM products p JOIN sales s
ON p.product_id = s.product_id
GROUP BY p.product_name
HAVING avg_rating < 3;

-- cities with total revenue greater or equal to INR200,000
SELECT * FROM city;
SELECT * FROM sales;
SELECT * FROM customers;

WITH city_sales AS (
			SELECT ci.city_name, SUM(s.total) AS total_revenue
			FROM city ci JOIN customers cu
			ON ci.city_id = cu.city_id
			JOIN sales s
			ON cu.customer_id = s.customer_id
			GROUP BY ci.city_name
			HAVING total_revenue >= 200000
			ORDER BY total_revenue DESC)
            
SELECT city_name, FORMAT(total_revenue, 0) AS total_revenue FROM city_sales;
		
-- Retrieve customers who have made at least 50 purchases
SELECT c.customer_name, COUNT(s.customer_id) AS total_purchases
FROM customers c JOIN sales s
ON c.customer_id = s.customer_id
GROUP BY c.customer_name
HAVING total_purchases >= 50
ORDER BY total_purchases DESC;

-- 17th March, 2026
-- Customer who has spent the most money overall
USE coffee_co;

SELECT * FROM customers;
SELECT * FROM sales;

SELECT c.customer_name, SUM(s.total) AS total_amount_spent
FROM customers c JOIN sales s
ON c.customer_id = s.customer_id
GROUP BY c.customer_name
ORDER BY total_amount_spent DESC
LIMIT 1;













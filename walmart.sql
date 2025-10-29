SELECT * FROM WALMART;

-- Business Problems
-- Q1:Find different payment methods, number of transactions, and quantity sold by payment method

SELECT payment_method,
COUNT(*) AS no_payments,
SUM(quantity) AS quantity_sold
FROM walmart
GROUP BY payment_method;

-- #2: Identify the highest-rated category in each branch
-- Display the branch, category, and avg rating

SELECT branch,category,avg_rating
FROM
(
SELECT
branch,category,AVG(rating)AS avg_rating,
RANK()OVER(PARTITION BY branch ORDER BY AVG(rating)DESC)AS rn
FROM WALMART
GROUP BY branch,category
)
AS ranked
WHERE rn = 1;

-- Q3: Identify the busiest day for each branch based on the number of transactions
SELECT branch,day_name,no_transaction
FROM(
 SELECT 
  branch,
  DAYNAME(str_to_date(date,'%d/%m/%Y')) AS day_name,
  COUNT(*) AS no_transaction,
  RANK() OVER(PARTITION BY branch ORDER BY COUNT(*)DESC)
AS raank
FROM walmart
GROUP BY branch,day_name)
AS ranked
WHERE raank=1;

-- Q4: Calculate the total quantity of items sold per payment method
SELECT payment_method,
SUM(quantity) AS item_sold
FROM walmart
GROUP BY payment_method;

-- Q5: Determine the average, minimum, and maximum rating of categories for each city
SELECT category,city,
MAX(rating) AS max_rating,
MIN(rating) AS min_rating,
AVG(rating) AS avg_rating
FROM walmart
GROUP BY category,city;


-- Q6: Calculate the total profit for each category
SELECT category,
SUM(unit_price*quantity*profit_margin) AS total_price
FROM walmart
GROUP BY category
ORDER BY total_price DESC;

-- Q7: Determine the most common payment method for each branch
WITH cte AS (
  SELECT
    branch,
    payment_method,
    COUNT(*) AS total_trans,
    RANK() OVER (PARTITION BY branch ORDER BY COUNT(*) DESC) AS rk
  FROM walmart
  GROUP BY branch, payment_method
)
SELECT
  branch,
  payment_method AS preferred_payment_method
FROM cte
WHERE rk = 1;




create database Zepto_SQL_Project;
use Zepto_SQL_Project;
SELECT * FROM zepto limit 10;

-- data exploration
-- count of rows 
SELECT COUNT(*) FROM zepto;

-- sample data
SELECT * FROM zepto 
LIMIT 10; 

ALTER TABLE zepto 
ADD COLUMN id INT NOT NULL AUTO_INCREMENT PRIMARY KEY FIRST;

-- null values
SELECT * FROM zepto 
WHERE category IS NULL
OR
name IS NULL
OR
mrp IS NULL
OR
discountPercent IS NULL
OR
availableQuantity IS NULL
OR
discountedSellingPrice IS NULL
OR
weightInGms IS NULL
OR
outOfStock IS NULL
OR
quantity IS NULL;

-- different product categories
SELECT DISTINCT category 
FROM zepto 
ORDER BY category;

-- product instock vs outofStock
SELECT outOfStock , COUNT(id)
FROM zepto
GROUP BY outOfStock;

-- product names present multiple times
SELECT name , COUNT(id) AS "Number of SKUs"
FROM zepto
GROUP BY name
HAVING COUNT(id)> 1
ORDER BY COUNT(id) DESC;

-- data cleaning
-- prooduct with price = 0
SELECT * FROM zepto
WHERE mrp = 0 OR discountedSellingPrice = 0;
SET SQL_SAFE_UPDATES=0;

DELETE FROM zepto 
WHERE mrp = 0;

-- convert paise into rupee
update zepto
set mrp = mrp/100.0,
discountedSellingPrice = discountedSellingPrice/100.0;

SELECT mrp , discountedSellingPrice FROM zepto;

-- Q1. find the top 10 best value products based on discount percentage.
SELECT DISTINCT name, mrp, discountPercent FROM zepto 
ORDER BY discountPercent DESC
LIMIT 10;

-- Q2. what are the products with high mrp but out of stock
SELECT DISTINCT name ,mrp FROM zepto 
WHERE outOfStock = FALSE
AND mrp >100
ORDER BY mrp DESC;

-- Q3.calculate Estimated Revenue For each Category
SELECT category , SUM(discountedSellingPrice * availableQuantity) AS total_revenue
FROM zepto 
GROUP BY category 
ORDER BY total_revenue;

-- Q4. Find all Product Where MRP is greater than RS500 and discount is less than 10%.
SELECT DISTINCT name , mrp , discountPercent FROM zepto
WHERE mrp > 500 AND discountPercent <10
ORDER BY mrp DESC , discountPercent DESC;

-- Q5.Identify the top 5 category offering the highest average discount percentage.
SELECT category, avg(discountPercent) AS average_discount
FROM zepto 
GROUP BY category
ORDER BY average_discount DESC LIMIT 5;

-- Q6.Find the price per gram for products above 100g and sort by best value.
SELECT DISTINCT name, weightInGms, discountedSellingPrice ,
round(discountedSellingPrice/weightInGms,2) AS price_per_gram
FROM zepto WHERE weightInGms >= 100
ORDER BY Price_per_gram;

-- Q7. Group all product into weight categories like LOW, MEDIUM, BULK.
SELECT DISTINCT name, weightInGms,
CASE WHEN weightInGms < 1000 THEN 'LOW'
    WHEN weightInGms <5000 THEN 'MEDIUM'
    ELSE 'BULK'
    END AS weight_category
FROM zepto;  

-- Q8. What is the total inventory weight per category. 
SELECT category , sum(weightInGms*availableQuantity) AS total_weight
FROM zepto 
GROUP BY category
ORDER BY total_weight DESC;

 




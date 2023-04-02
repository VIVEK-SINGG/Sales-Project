--1. What is the total sales revenue for each product category and sub-category?

WITH revenue_cte AS (
SELECT
category,
[Sub-Category],
CAST(SUM(sales * quantity) AS INT) AS revenue
FROM [Orders$]
GROUP BY category, [Sub-Category]
)
SELECT
category,
[Sub-Category],
revenue
FROM revenue_cte
ORDER BY revenue DESC;

--2. What is the total profit for each product category and sub-category?

SELECT
Category,
[Sub-Category],
[Product Name],
Total_profit
FROM (
SELECT
Category,
[Sub-Category],
[Product Name],
CAST(SUM(Profit) AS INT) AS Total_profit,
RANK() OVER (PARTITION BY Category, [Sub-Category] ORDER BY SUM(Profit) DESC) AS Profit_Rank
FROM [Orders$]
GROUP BY Category, [Sub-Category], [Product Name]
) AS ProfitsByProduct
WHERE Profit_Rank = 1
ORDER BY Total_profit DESC;

--3. What is the average discount percentage for category and sub-category?

SELECT
Category,
[Sub-Category],
CONCAT(CAST(CASE WHEN AVG(Discount / (Sales / Quantity)) = 0
THEN 'No discounts applied'
ELSE AVG(Discount / (Sales / Quantity)) * 100 END AS INT), '%') AS Avg_Discount_Percentage
FROM [Orders$]
GROUP BY Category, [Sub-Category]
ORDER BY Avg_Discount_Percentage DESC;

--4. What is the distribution of sales by consumer segment and region?

SELECT
region,
segment,
CAST(SUM(sales) AS INT) AS total_sales
FROM Orders$
GROUP BY region, segment;

--5. What is the trend of sales over time, by year and month?

SELECT
YEAR([Order Date]) AS [Year],
MONTH([Order Date]) AS [Month],
CAST(SUM(Sales) AS INT) AS TotalSales
FROM [Orders$]
GROUP BY YEAR([Order Date]), MONTH([Order Date])
ORDER BY [Year], [Month];

--6. Which product categories and sub-categories are the most profitable and which ones are the least profitable?

WITH Profitability AS (
SELECT
Category,
[Sub-Category],
CAST(SUM(Profit) AS INT) AS TotalProfit
FROM [Orders$]
GROUP BY Category, [Sub-Category]
)

SELECT
Category,
[Sub-Category],
TotalProfit,
CASE
WHEN TotalProfit >= MAX(TotalProfit) OVER() * 0.75 THEN 'Most Profitable'
WHEN TotalProfit <= MAX(TotalProfit) OVER() * 0.25 THEN 'Least Profitable'
ELSE 'Moderately Profitable'
END AS ProfitabilityRank
FROM Profitability
ORDER BY TotalProfit DESC;

--7. What is the average order value and how does it vary by product category and sub-category?

SELECT
category,
[Sub-Category],
CAST(AVG(sales/Quantity) AS INT) AS average_sale
FROM Orders$
GROUP BY category, [Sub-Category]
ORDER BY average_sale DESC;

--8. Which customers have placed the most orders and have the highest sales volume?

SELECT DISTINCT TOP 10
[Customer Name],
OrderCount,
TotalSales
FROM (
SELECT
[Customer Name],
COUNT([Order ID]) AS OrderCount,
CAST(SUM(Sales) AS INT) AS TotalSales
FROM [Orders$]
GROUP BY [Customer Name]
)
as Customer_Sales
ORDER BY TotalSales

--9.What is the relationship between sales, profit, and discount, and how does it vary by category and sub-category?

SELECT 
    Category,
    [Sub-Category],
    CAST(AVG(Sales) AS INT) AS AvgSales,
    CAST(AVG(Profit) AS INT) AS AvgProfit,
    CAST(AVG(Discount) AS INT) AS AvgDiscount
FROM Orders$
GROUP BY Category,[Sub-Category]
ORDER BY AvgSales DESC

--10. What is the total revenue by state?

SELECT
[State],
city,
CAST(SUM(Sales / Quantity) AS INT) AS revenue
FROM Orders$
GROUP BY [State], city
ORDER BY revenue DESC;






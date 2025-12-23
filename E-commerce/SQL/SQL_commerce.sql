Select *
From PortfolioProject.dbo.ecommerce_sales_34500 E
order by product_id desc


--Top 3 customers in each region
WITH BASIC_CTE AS (
    SELECT
        customer_id, profit_margin,
        Region,
        RANK() OVER (PARTITION BY region ORDER BY profit_margin DESC) as Ranking_Score
    FROM
        PortfolioProject.dbo.ecommerce_sales_34500
)
SELECT *
FROM BASIC_CTE
WHERE Ranking_Score <= 3


--The "Growth" Check
Select  order_date,region, profit_margin,LAG(profit_margin) OVER (Partition BY region order by order_date) as Previous_Profit_Margin
From PortfolioProject.dbo.ecommerce_sales_34500 E


--Rolling profit margin 

Select  order_date,region, profit_margin, SUM(CAST(profit_margin AS FLOAT)) OVER (Partition BY region ORDER BY order_date asc) as Total_Profit_Margin
From PortfolioProject.dbo.ecommerce_sales_34500 E


--Labling orders
Select   customer_id,order_id, price,order_date,region, profit_margin,
(CASE WHEN price > 500 THEN 'High_Vlue'
ELSE 'Low_Value'
END) as Value
From PortfolioProject.dbo.ecommerce_sales_34500 E

--Highest profitable products from each category
;WITH Profit_CTE AS (
Select  product_id, category, quantity, profit_margin,
RANK() OVER (Partition BY category ORDER BY profit_margin DESC) Rank_profit 
From PortfolioProject.dbo.ecommerce_sales_34500 E
)
Select *
From Profit_CTE
Where Rank_profit <= 3
Order by category

--Farthest regions 

Select AVG(CAST(delivery_time_days AS INT)) AS AVG_Delivery_Days
,region
From PortfolioProject.dbo.ecommerce_sales_34500 E
GROUP BY region


--Highet profitable regions

Select region, AVG(CAST(profit_margin AS FLOAT)) AS Highest_Profit
From PortfolioProject.dbo.ecommerce_sales_34500 E
GROUP BY region
ORDER BY Highest_Profit DESC

--Highest regions in return rate 

SELECT 
    region,
    COUNT(order_id) as Total_Orders,
    COUNT(CASE WHEN returned = 'Yes' THEN 1 END) as Returned_Orders,
    CAST(COUNT(CASE WHEN returned = 'Yes' THEN 1 END) AS FLOAT) / COUNT(order_id) * 100 as Return_Rate_Percent
FROM 
    PortfolioProject.dbo.ecommerce_sales_34500 E
GROUP BY 
    region
ORDER BY 
    Return_Rate_Percent DESC








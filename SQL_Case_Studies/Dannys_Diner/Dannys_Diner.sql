

--What is the total amount each customer spent at the restaurant?

SELECT customer_id, SUM(price) AS Total_Money_Spent
FROM Dannys_Diner.dbo.menu
FULL JOIN Dannys_Diner.dbo.sales
ON Dannys_Diner.dbo.menu.product_id = Dannys_Diner.dbo.sales.product_id
GROUP BY customer_id


--How many days has each customer visited the restaurant?
SELECT customer_id, COUNT(DISTINCT order_date) AS NUM_Of_Visits 
FROM Dannys_Diner.dbo.sales
GROUP BY customer_id


--What was the first item from the menu purchased by each customer?

WITH RANK_TOT AS
(
SELECT DISTINCT customer_id, order_date,product_name , RANK () OVER (PARTITION BY customer_id ORDER BY order_date ASC) AS rnk
FROM Dannys_Diner.dbo.sales S
JOIN Dannys_Diner.dbo.menu M
ON S.product_id = M.product_id
)
SELECT customer_id, order_date,product_name 
FROM RANK_TOT
WHERE rnk = 1

--What is the most purchased item on the menu and how many times was it purchased by all customers?
WITH TOT AS
(
SELECT  S.product_id, product_name, price ,COUNT (S.customer_id) OVER (PARTITION BY S.product_id ORDER BY S.product_id) AS Total_Purchased
FROM Dannys_Diner.dbo.sales S
JOIN Dannys_Diner.dbo.menu M
ON S.product_id = M.product_id
)
SELECT product_id, product_name, MAX(price) AS Cost, MAX(Total_Purchased) AS Times_Bought
FROM TOT
GROUP BY product_id, product_name

--Which item was the most popular for each customer?
WITH PAIN AS 
(
SELECT  customer_id, product_id, COUNT(product_id) AS counting
FROM Dannys_Diner.dbo.sales S
GROUP BY product_id, customer_id
),
ULTRA_PAIN AS (
SELECT  customer_id, product_id, MAX(counting) AS Times_Bought, DENSE_RANK () OVER (PARTITION BY customer_id ORDER BY MAX(counting) DESC) rnk
FROM PAIN
GROUP BY customer_id, product_id
)
SELECT *
FROM ULTRA_PAIN
WHERE rnk = 1

--Which item was purchased first by the customer after they became a member
 WITH RANKING AS(
 SELECT S.customer_id, order_date, join_date, product_id, RANK () OVER (PARTITION BY S.customer_id ORDER BY order_date) Order_rank
FROM Dannys_Diner.dbo.sales S
JOIN Dannys_Diner.dbo.members M
ON S.customer_id = M.customer_id
WHERE order_date >= join_date
)
SELECT customer_id, order_date, join_date, product_id
FROM RANKING
WHERE Order_rank = 1 


--What is the total items and amount spent for each member before they became a member?

WITH I_LOVE_CTE AS (
SELECT S.customer_id, order_date, join_date, product_id
FROM Dannys_Diner.dbo.sales S
JOIN Dannys_Diner.dbo.members M
ON S.customer_id = M.customer_id
WHERE order_date < join_date
)
SELECT customer_id, C.product_id, product_name , SUM(price) AS MUCH_PAID, COUNT (price) AS Times_Bought
FROM I_LOVE_CTE C
JOIN Dannys_Diner.dbo.menu M
ON C.product_id = M.product_id
GROUP BY customer_id, C.product_id, product_name

--If each $1 spent equates to 10 points and sushi has a 2x points multiplier — how many points would each customer have?
WITH ANOTHER_CTE AS (
SELECT customer_id, S.product_id, product_name, price, (price*10) AS POINTS 
FROM Dannys_Diner.dbo.sales S
JOIN Dannys_Diner.dbo.menu M
ON S.product_id = M.product_id
),
MORE_CTE AS(
SELECT customer_id, product_id, product_name, price, POINTS,
CASE 
WHEN product_name = 'sushi' THEN (POINTS*2) 
ELSE POINTS
END AS ALL_Points
FROM ANOTHER_CTE
)
SELECT customer_id, SUM(ALl_Points) AS Total_Points
FROM MORE_CTE
GROUP BY customer_id


--Ordering ... orders?

WITH Tiny_CTE AS(
SELECT S.customer_id, order_date, join_date, product_id,
CASE
WHEN order_date >= join_date THEN 'Y'
WHEN order_date < join_date THEN 'N'
ELSE 'N'
END AS Member_status
FROM Dannys_Diner.dbo.sales S
FULL JOIN Dannys_Diner.dbo.members M
ON S.customer_id = M.customer_id
)
SELECT customer_id, order_date, join_date, C.product_id, product_name, price,Member_status,
CASE 
WHEN Member_status = 'N' THEN NULL
ELSE
RANK () OVER (PARTITION BY customer_id, Member_status ORDER BY order_date) 
END AS Useless_Rank
FROM Tiny_CTE C
JOIN Dannys_Diner.dbo.menu M
ON C.product_id = M.product_id
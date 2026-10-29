/*
ILLUSTRATIVE READ-ONLY T-SQL, NOT ORIGINAL SUBMITTED PROJECT CODE.
NOT executed against Karan Mahalik's actual data. Requires imported tables
matching the PROPOSED contract in 01_schema_contract.sql. No DDL or DELETE.
*/

-- 1. Monthly gross sales and order counts
WITH OrderValue AS (
  SELECT o.OrderID, o.OrderDate,
         SUM(CAST(i.Quantity AS decimal(18,2)) * i.UnitPrice) AS Revenue
  FROM dbo.Orders AS o
  JOIN dbo.OrderItems AS i ON i.OrderID = o.OrderID
  WHERE i.Quantity > 0 AND i.UnitPrice >= 0
  GROUP BY o.OrderID, o.OrderDate
)
SELECT DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) AS SalesMonth,
       COUNT(*) AS OrderCount, SUM(Revenue) AS GrossSales
FROM OrderValue
GROUP BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1)
ORDER BY SalesMonth;

-- 2. Sales by channel and calendar quarter
WITH OrderValue AS (
  SELECT o.OrderID, o.OrderDate, o.Channel,
         SUM(CAST(i.Quantity AS decimal(18,2)) * i.UnitPrice) AS Revenue
  FROM dbo.Orders AS o
  JOIN dbo.OrderItems AS i ON i.OrderID = o.OrderID
  WHERE i.Quantity > 0 AND i.UnitPrice >= 0
  GROUP BY o.OrderID, o.OrderDate, o.Channel
)
SELECT YEAR(OrderDate) AS SalesYear,
       DATEPART(QUARTER,OrderDate) AS SalesQuarter,
       Channel, COUNT(*) AS OrderCount, SUM(Revenue) AS GrossSales
FROM OrderValue
GROUP BY YEAR(OrderDate),DATEPART(QUARTER,OrderDate),Channel
ORDER BY SalesYear,SalesQuarter,Channel;

-- 3. Product ranking by revenue
SELECT p.ProductID, p.ProductName, p.Category,
       SUM(CAST(i.Quantity AS decimal(18,2)) * i.UnitPrice) AS GrossSales,
       DENSE_RANK() OVER (ORDER BY SUM(CAST(i.Quantity AS decimal(18,2)) * i.UnitPrice) DESC) AS RevenueRank
FROM dbo.OrderItems AS i
JOIN dbo.Products AS p ON p.ProductID = i.ProductID
WHERE i.Quantity > 0 AND i.UnitPrice >= 0
GROUP BY p.ProductID,p.ProductName,p.Category
ORDER BY RevenueRank,p.ProductName;

-- 4. Repeat customers over the available lifetime (not per month)
SELECT CustomerID, COUNT(DISTINCT OrderID) AS OrdersPlaced
FROM dbo.Orders
WHERE CustomerID IS NOT NULL
GROUP BY CustomerID
HAVING COUNT(DISTINCT OrderID) > 1
ORDER BY OrdersPlaced DESC;

-- 5. Order return incidence (distinct orders with linked return records)
SELECT COUNT(DISTINCT r.OrderID) AS OrdersWithReturns,
       (SELECT COUNT(DISTINCT OrderID) FROM dbo.Orders) AS AllOrders,
       CAST(COUNT(DISTINCT r.OrderID) AS decimal(18,4))
         / NULLIF((SELECT COUNT(DISTINCT OrderID) FROM dbo.Orders),0) AS OrderReturnRate
FROM dbo.Returns AS r
JOIN dbo.Orders AS o ON o.OrderID = r.OrderID;

-- 6. Monthly running revenue and growth
WITH Monthly AS (
  SELECT DATEFROMPARTS(YEAR(o.OrderDate), MONTH(o.OrderDate),1) AS SalesMonth,
         SUM(CAST(i.Quantity AS decimal(18,2)) * i.UnitPrice) AS GrossSales
  FROM dbo.Orders o JOIN dbo.OrderItems i ON i.OrderID=o.OrderID
  WHERE i.Quantity > 0 AND i.UnitPrice >= 0
  GROUP BY DATEFROMPARTS(YEAR(o.OrderDate),MONTH(o.OrderDate),1)
), Series AS (
  SELECT SalesMonth, GrossSales,
         LAG(GrossSales) OVER(ORDER BY SalesMonth) AS PreviousMonthSales,
         SUM(GrossSales) OVER(ORDER BY SalesMonth ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningSales
  FROM Monthly
)
SELECT SalesMonth,GrossSales,PreviousMonthSales,RunningSales,
       (GrossSales - PreviousMonthSales) / NULLIF(PreviousMonthSales,0) AS MoMGrowthRatio
FROM Series ORDER BY SalesMonth;

-- 7. Mean delivery duration, excluding invalid date sequences
SELECT AVG(CAST(DATEDIFF(DAY,ShippedDate,DeliveredDate) AS decimal(18,2))) AS AverageDeliveryDays
FROM dbo.Orders
WHERE ShippedDate IS NOT NULL
  AND DeliveredDate IS NOT NULL
  AND DeliveredDate >= ShippedDate;

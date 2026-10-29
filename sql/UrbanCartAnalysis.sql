/* Functional Requirements — SQL (Analysis Phase)
•	FR13: Load cleaned tables into a relational database (PostgreSQL, MySQL, or SQLite) with primary/foreign keys and constraints.
•	FR14: Build queries to answer:
–	Revenue trend by month, quarter, and year
–	Revenue and order volume by Region, State, and City
–	Top-performing categories, sub-categories, and products
–	Revenue by Channel (Online vs Store) and by Payment Mode
–	Customer segment performance (Regular/Premium/VIP): average order value, order frequency
–	Return rate by category/product and the top return reasons
–	Repeat-customer rate (customers with 2+ orders)
–	Average delivery time (ShipDate to DeliveryDate) by region
•	FR15: Use window functions (running totals, rank, month-over-month % change) in at least two analyses.
•	FR16: Create reusable SQL views for the metrics that will feed Power BI.
•	FR17: Document each query with its business question and expected output.

*/
Select * From Customers;
Select * From Order_Items;
Select * From Orders;
Select * from Products;
Select * From Returns;

--Revenue trend by month, quarter, and year
Select DATEPART(Year,OD.OrderDate) AS Years, SUM(OI.LineTotal) AS Revenue From Orders OD
         INNER JOIN 
         Order_Items OI
         ON OD.OrderID = OI.OrderID
         GROUP BY 
         DATEPART(Year,OD.OrderDate);


Select DATEPART(QUARTER,OD.OrderDate) AS Quaterly, SUM(OI.LineTotal) AS Revenue From Orders OD
         INNER JOIN 
         Order_Items OI
         ON OD.OrderID = OI.OrderID
         GROUP BY 
         DATEPART(QUARTER,OD.OrderDate)
         ORDER BY
         DATEPART(QUARTER,OD.OrderDate) ASC;


Select DATEPART(MONTH,OD.OrderDate) AS Monthly, SUM(OI.LineTotal) AS Revenue From Orders OD
         INNER JOIN 
         Order_Items OI
         ON OD.OrderID = OI.OrderID
         GROUP BY 
         DATEPART(MONTH,OD.OrderDate)
         ORDER BY
         DATEPART(MONTH,OD.OrderDate) ASC;


--–	Revenue and order volume by Region, State
Select OD.Region, OD.State, SUM(LineTotal) AS Revenue, COUNT(OD.OrderID) AS OrderVolume From Orders OD
         INNER JOIN 
         Order_Items OI
         ON OD.OrderID = OI.OrderID
         GROUP BY 
         OD.Region, OD.State;


-- Top-performing categories, sub-categories, and products
Select TOP 5 PD.Category,
       SUM(LineTotal) AS Revenue
       From Products PD
         INNER JOIN
         Order_Items OI
         ON PD.ProductID = OI.ProductID
         GROUP BY
         PD.Category
         ORDER BY 
         SUM(LineTotal) DESC


Select TOP 5
       PD.SubCategory , 
       SUM(LineTotal) AS Revenue
       From Products PD
         INNER JOIN
         Order_Items OI
         ON PD.ProductID = OI.ProductID
         GROUP BY
         PD.SubCategory
         ORDER BY 
         SUM(LineTotal) DESC


Select TOP 5 
       PD.ProductName,
       SUM(LineTotal) AS Revenue
       From Products PD
         INNER JOIN
         Order_Items OI
         ON PD.ProductID = OI.ProductID
         GROUP BY 
         PD.ProductName
         ORDER BY 
         SUM(LineTotal) DESC


--Revenue by Channel (Online vs Store) and by Payment Mode

BEGIN TRANSACTION;

UPDATE Orders
SET Channel = TRIM(Channel)
WHERE Channel <> TRIM(Channel);

-- Verify the results
SELECT DISTINCT Channel
FROM Orders;

-- Save changes if correct
COMMIT TRANSACTION;

-- Or use ROLLBACK instead of COMMIT
-- to undo changes
Select OD.Channel,  SUM(OI.LineTotal) AS Revenue From Orders OD
         INNER JOIN 
         Order_Items OI
         ON
         OD.OrderID = OI.OrderID
         GROUP BY 
         OD.Channel;


Select OD.PaymentMode, SUM(OI.LineTotal) AS Revenue From Orders OD
         INNER JOIN 
         Order_Items OI
         ON
         OD.OrderID = OI.OrderID
         GROUP BY 
         OD.PaymentMode;

--Customer segment performance (Regular/Premium/VIP): average order value, order frequency
Select CU.CustomerSegment,
         CONCAT(ROUND(SUM(OI.LineTotal) / COUNT(DISTINCT OD.OrderID), 2), 'INR') AS AOV,
         COUNT(DISTINCT OD.OrderID) / COUNT(DISTINCT CU.CustomerID) AS 'Order Frequency'
         From Orders OD
         INNER JOIN 
         Order_Items OI 
         ON OD.OrderID = OI.OrderID
         INNER JOIN
         Customers CU
         ON OD.CustomerID = CU.CustomerID
         GROUP BY 
         CU.CustomerSegment


/* Return rate by category/product and top return reasons */

SELECT TOP 5
    p.Category,
    r.ReturnReason,

    -- Return Rate (%)
    CAST(
        COUNT(DISTINCT r.ReturnID) * 100.0
        / NULLIF(COUNT(DISTINCT oi.OrderItemID), 0)
        AS DECIMAL(10,2)
    ) AS Return_Rate,

    -- Total Returns
    COUNT(DISTINCT r.ReturnID) AS ReturnCount

FROM Products AS p
INNER JOIN Returns AS r
    ON p.ProductID = r.ProductID
INNER JOIN Order_Items AS oi
    ON r.OrderID = oi.OrderID

GROUP BY
    p.Category,
    r.ReturnReason

ORDER BY
    COUNT(DISTINCT r.ReturnID) DESC;



Select * From Customers;
Select * From Order_Items;
Select * From Orders;
Select * from Products;
Select * From Returns;

--Repeat-customer rate (customers with 2+ orders)
Select 
(Select Count(Repeat_Customer) AS RepeatCustCount From 
(Select CustomerID,
       COUNT(CustomerID) AS Repeat_Customer
       From Orders
       GROUP BY 
       CustomerID
       Having COUNT(CustomerID) > 1
       ) As ReturnRate) / COUNT(DISTINCT CustomerID) * 100.00 AS 'Repeat Customer' FROM Customers

SELECT
    ROUND(
        (
            SELECT COUNT(Repeat_Customer)
            FROM (
                SELECT
                    CustomerID,
                    COUNT(CustomerID) AS Repeat_Customer
                FROM Orders
                GROUP BY CustomerID
                HAVING COUNT(CustomerID) > 1
            ) AS ReturnRate
        ) * 100.0
        / NULLIF(COUNT(DISTINCT CustomerID), 0),
        0
    ) AS [Repeat Customer]
FROM Customers;

--Average delivery time (ShipDate to DeliveryDate) by region
Select Region, 
       AVG(DATEDIFF(DAY,ShipDate,DeliveryDate)) AS [Avg Delevery Days]
       From Orders
       GROUP BY 
       Region;

--Use window functions (running totals, rank, month-over-month % change) in at least two analyses.

SELECT
    DATEFROMPARTS(
        YEAR(OD.OrderDate),
        MONTH(OD.OrderDate),
        1
    ) AS MonthStart,
    YEAR(OD.OrderDate) AS [Year],
    DATEPART(QUARTER, OD.OrderDate) AS [Quarter],
    MONTH(OD.OrderDate) AS MonthNumber,
    SUM(OI.LineTotal) AS Revenue,
    COUNT(DISTINCT OD.OrderID) AS OrderVolume
FROM Orders AS OD
INNER JOIN Order_Items AS OI
    ON OD.OrderID = OI.OrderID
GROUP BY
    DATEFROMPARTS(YEAR(OD.OrderDate), MONTH(OD.OrderDate), 1),
    YEAR(OD.OrderDate),
    DATEPART(QUARTER, OD.OrderDate),
    MONTH(OD.OrderDate);
























/*========================================================
  1. REVENUE TREND BY MONTH, QUARTER, AND YEAR
========================================================*/

CREATE VIEW vw_RevenueTrend
AS
SELECT
    DATEFROMPARTS(
        YEAR(OD.OrderDate),
        MONTH(OD.OrderDate),
        1
    ) AS MonthStart,
    YEAR(OD.OrderDate) AS [Year],
    DATEPART(QUARTER, OD.OrderDate) AS [Quarter],
    MONTH(OD.OrderDate) AS MonthNumber,
    SUM(OI.LineTotal) AS Revenue,
    COUNT(DISTINCT OD.OrderID) AS OrderVolume
FROM Orders AS OD
INNER JOIN Order_Items AS OI
    ON OD.OrderID = OI.OrderID
GROUP BY
    DATEFROMPARTS(YEAR(OD.OrderDate), MONTH(OD.OrderDate), 1),
    YEAR(OD.OrderDate),
    DATEPART(QUARTER, OD.OrderDate),
    MONTH(OD.OrderDate);
GO
Select * From vw_RevenueTrend;

/*========================================================
  2. REVENUE AND ORDER VOLUME BY REGION AND STATE
========================================================*/

CREATE OR ALTER VIEW vw_RegionalSalesPerformance
AS
SELECT
    OD.Region,
    OD.State,
    SUM(OI.LineTotal) AS Revenue,
    COUNT(DISTINCT OD.OrderID) AS OrderVolume
FROM Orders AS OD
INNER JOIN Order_Items AS OI
    ON OD.OrderID = OI.OrderID
GROUP BY
    OD.Region,
    OD.State;
GO


/*========================================================
  3. TOP-PERFORMING CATEGORIES, SUBCATEGORIES, PRODUCTS
========================================================*/

CREATE OR ALTER VIEW vw_ProductPerformance
AS
SELECT
    PD.Category,
    PD.SubCategory,
    PD.ProductID,
    PD.ProductName,
    SUM(OI.LineTotal) AS Revenue,
    SUM(OI.Quantity) AS UnitsSold,
    COUNT(DISTINCT OI.OrderID) AS OrderVolume
FROM Products AS PD
INNER JOIN Order_Items AS OI
    ON PD.ProductID = OI.ProductID
GROUP BY
    PD.Category,
    PD.SubCategory,
    PD.ProductID,
    PD.ProductName;
GO


/*========================================================
  4. REVENUE BY CHANNEL (ONLINE VS STORE)
========================================================*/

CREATE OR ALTER VIEW vw_ChannelRevenue
AS
SELECT
    TRIM(OD.Channel) AS Channel,
    SUM(OI.LineTotal) AS Revenue,
    COUNT(DISTINCT OD.OrderID) AS OrderVolume
FROM Orders AS OD
INNER JOIN Order_Items AS OI
    ON OD.OrderID = OI.OrderID
GROUP BY
    TRIM(OD.Channel);
GO


/*========================================================
  5. REVENUE BY PAYMENT MODE
========================================================*/

CREATE OR ALTER VIEW vw_PaymentModeRevenue
AS
SELECT
    OD.PaymentMode,
    SUM(OI.LineTotal) AS Revenue,
    COUNT(DISTINCT OD.OrderID) AS OrderVolume
FROM Orders AS OD
INNER JOIN Order_Items AS OI
    ON OD.OrderID = OI.OrderID
GROUP BY
    OD.PaymentMode;
GO


/*========================================================
  6. CUSTOMER SEGMENT PERFORMANCE
     AOV, ORDER FREQUENCY, REVENUE, CUSTOMER COUNT
========================================================*/

CREATE OR ALTER VIEW vw_CustomerSegmentPerformance
AS
WITH OrderTotals AS
(
    SELECT
        OD.OrderID,
        OD.CustomerID,
        SUM(OI.LineTotal) AS OrderRevenue
    FROM Orders AS OD
    INNER JOIN Order_Items AS OI
        ON OD.OrderID = OI.OrderID
    GROUP BY
        OD.OrderID,
        OD.CustomerID
)
SELECT
    CU.CustomerSegment,
    COALESCE(SUM(OT.OrderRevenue), 0) AS TotalRevenue,
    COUNT(DISTINCT OT.OrderID) AS TotalOrders,
    COUNT(DISTINCT CU.CustomerID) AS TotalCustomers,

    CAST(
        COALESCE(SUM(OT.OrderRevenue), 0) * 1.0
        / NULLIF(COUNT(DISTINCT OT.OrderID), 0)
        AS DECIMAL(12, 2)
    ) AS AOV,

    CAST(
        COUNT(DISTINCT OT.OrderID) * 1.0
        / NULLIF(COUNT(DISTINCT CU.CustomerID), 0)
        AS DECIMAL(10, 2)
    ) AS OrderFrequency

FROM Customers AS CU
LEFT JOIN OrderTotals AS OT
    ON CU.CustomerID = OT.CustomerID
GROUP BY
    CU.CustomerSegment;
GO


/*========================================================
  7. RETURN RATE BY CATEGORY AND RETURN REASON
========================================================*/

CREATE OR ALTER VIEW vw_ReturnAnalysis
AS
WITH CategorySales AS
(
    SELECT
        PD.Category,
        COUNT(DISTINCT OI.OrderItemID) AS TotalItemsSold
    FROM Products AS PD
    INNER JOIN Order_Items AS OI
        ON PD.ProductID = OI.ProductID
    GROUP BY
        PD.Category
),
ReturnCounts AS
(
    SELECT
        PD.Category,
        R.ReturnReason,
        COUNT(DISTINCT R.ReturnID) AS ReturnCount
    FROM Returns AS R
    INNER JOIN Products AS PD
        ON R.ProductID = PD.ProductID
    GROUP BY
        PD.Category,
        R.ReturnReason
)
SELECT
    RC.Category,
    RC.ReturnReason,
    RC.ReturnCount,
    CS.TotalItemsSold,

    CAST(
        RC.ReturnCount * 100.0
        / NULLIF(CS.TotalItemsSold, 0)
        AS DECIMAL(10, 2)
    ) AS ReturnRate

FROM ReturnCounts AS RC
INNER JOIN CategorySales AS CS
    ON RC.Category = CS.Category;
GO


/*========================================================
  8. REPEAT-CUSTOMER RATE
     CUSTOMERS WITH TWO OR MORE DISTINCT ORDERS
========================================================*/

CREATE OR ALTER VIEW vw_RepeatCustomerRate
AS
WITH CustomerOrders AS
(
    SELECT
        CustomerID,
        COUNT(DISTINCT OrderID) AS TotalOrders
    FROM Orders
    GROUP BY
        CustomerID
)
SELECT
    COUNT(
        CASE
            WHEN COALESCE(CO.TotalOrders, 0) >= 2 THEN 1
        END
    ) AS RepeatCustomers,

    COUNT(CU.CustomerID) AS TotalCustomers,

    CAST(
        ROUND(
            COUNT(
                CASE
                    WHEN COALESCE(CO.TotalOrders, 0) >= 2 THEN 1
                END
            ) * 100.0
            / NULLIF(COUNT(CU.CustomerID), 0),
            0
        ) AS INT
    ) AS RepeatCustomerRate

FROM Customers AS CU
LEFT JOIN CustomerOrders AS CO
    ON CU.CustomerID = CO.CustomerID;
GO


/*========================================================
  9. AVERAGE DELIVERY TIME BY REGION
========================================================*/

CREATE OR ALTER VIEW vw_AverageDeliveryTime
AS
SELECT
    Region,
    COUNT(DISTINCT OrderID) AS DeliveredOrders,

    CAST(
        AVG(
            DATEDIFF(DAY, ShipDate, DeliveryDate) * 1.0
        ) AS DECIMAL(10, 2)
    ) AS AvgDeliveryDays

FROM Orders
WHERE ShipDate IS NOT NULL
  AND DeliveryDate IS NOT NULL
  AND DeliveryDate >= ShipDate
GROUP BY
    Region;
GO


/*========================================================
  10. TEST ALL VIEWS
========================================================*/

SELECT * FROM vw_RevenueTrend
ORDER BY MonthStart;

SELECT * FROM vw_RegionalSalesPerformance;

SELECT * FROM vw_ProductPerformance
ORDER BY Revenue DESC;

SELECT * FROM vw_ChannelRevenue;

SELECT * FROM vw_PaymentModeRevenue;

SELECT * FROM vw_CustomerSegmentPerformance;

SELECT * FROM vw_ReturnAnalysis
ORDER BY ReturnCount DESC;

SELECT * FROM vw_RepeatCustomerRate;

SELECT * FROM vw_AverageDeliveryTime
ORDER BY AvgDeliveryDays DESC;


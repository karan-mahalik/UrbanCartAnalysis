/* =====================================================================
   SCHEMA + LOAD SCRIPT  (SQL Server / T-SQL)
   Source tables (read from your SSMS screen recording):
     dbo.Customers_Clean, dbo.Products_Clean, dbo.Orders_Clean,
     dbo.Order_Items_Clean, dbo.Return_Clean
   Target tables (created here):
     dbo.Customers, dbo.Products, dbo.Orders, dbo.Order_Items, dbo.Returns

   HOW TO USE (run top to bottom, one STEP at a time):
     STEP 0  Select the database
     STEP 1  Pre-load data checks on the _Clean tables (read-only)
     STEP 2  Create the tables (CREATE statements)
     STEP 3  Create supporting indexes
     STEP 4  Load data from the _Clean tables (in FK-safe order)
     STEP 5  Verify row counts and relationships
     STEP 6  (Optional) Rollback / cleanup

   ASSUMPTIONS TO CONFIRM BEFORE RUNNING
     * ID columns fit in NVARCHAR(50)  -> STEP 1 proves it.
     * Money columns are decimal(12,2); Quantity is a whole number.
     * Discount is stored as a fraction/percent value up to 9999.9999;
       adjust precision if yours differs.
     * CalculatedOrderStatus was truncated on screen; assumed nvarchar(255).
     * "Return" is a reserved word, so the target table is named Returns.
     * Target database is UrbanCart (STEP 0 selects it).
   ===================================================================== */


/* ---------------------------------------------------------------------
   STEP 0: Select your database.
   --------------------------------------------------------------------- */
USE [UrbanCart];
GO


/* ---------------------------------------------------------------------
   STEP 1: PRE-LOAD CHECKS (read-only). Every query should return 0 rows
           (or 0) before you continue. Fix the source data if not.
   --------------------------------------------------------------------- */

-- 1a. Longest ID values (must be <= 50)
SELECT 'Customers_Clean.customerid' AS col, MAX(LEN(customerid)) AS max_len FROM dbo.Customers_Clean
UNION ALL SELECT 'Products_Clean.ProductID',   MAX(LEN(ProductID))   FROM dbo.Products_Clean
UNION ALL SELECT 'Orders_Clean.OrderID',       MAX(LEN(OrderID))     FROM dbo.Orders_Clean
UNION ALL SELECT 'Order_Items_Clean.OrderItemID', MAX(LEN(OrderItemID)) FROM dbo.Order_Items_Clean
UNION ALL SELECT 'Return_Clean.ReturnID',      MAX(LEN(ReturnID))    FROM dbo.Return_Clean;

-- 1b. Duplicate primary keys
SELECT customerid, COUNT(*) AS n FROM dbo.Customers_Clean   GROUP BY customerid  HAVING COUNT(*) > 1;
SELECT ProductID,  COUNT(*) AS n FROM dbo.Products_Clean    GROUP BY ProductID   HAVING COUNT(*) > 1;
SELECT OrderID,    COUNT(*) AS n FROM dbo.Orders_Clean      GROUP BY OrderID     HAVING COUNT(*) > 1;
SELECT OrderItemID,COUNT(*) AS n FROM dbo.Order_Items_Clean GROUP BY OrderItemID HAVING COUNT(*) > 1;
SELECT ReturnID,   COUNT(*) AS n FROM dbo.Return_Clean      GROUP BY ReturnID    HAVING COUNT(*) > 1;


Select * From Order_Items_Clean;

----Delete CAnt be use by subquery because its directly dlete the Whole data ---------------------
DELETE From Order_Items_Clean
WHERE EXISts
(SELECT OrderItemID,COUNT(*) AS n FROM dbo.Order_Items_Clean GROUP BY OrderItemID HAVING COUNT(*) > 1);
--------------------------------------------------------------------------------------------------------

WITH CTE AS (
Select OrderItemID,
        ROW_NUMBER()  OVER(PARTITION BY OrderItemID Order by OrderItemID DESC) Duplicate
        From Order_Items_Clean
        )
        Select * From CTE 
        WHERE Duplicate > 1;


WITH CTE AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY OrderItemID
               ORDER BY OrderID, ProductID, Quantity,
                        UnitPriceAtSale, [Discount ], LineTotal
           ) AS rn
    FROM dbo.Order_Items_Clean
)
SELECT *
FROM CTE
WHERE rn > 1;


----Delete Duplicate

BEGIN TRANSACTION;
WITH CTE AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY OrderItemID
               ORDER BY OrderID, ProductID, Quantity,
                        UnitPriceAtSale, [Discount ], LineTotal
           ) AS rn
    FROM dbo.Order_Items_Clean
)
DELETE
FROM CTE
WHERE rn > 1;

ROLLBACK TRANSACTION;
COMMIT TRANSACTION;

-- 1c. Orphan foreign keys (child rows with no parent)
SELECT o.OrderID, o.CustomerID
FROM dbo.Orders_Clean o
LEFT JOIN dbo.Customers_Clean c ON c.customerid = o.CustomerID
WHERE c.customerid IS NULL;

SELECT oi.OrderItemID, oi.OrderID
FROM dbo.Order_Items_Clean oi
LEFT JOIN dbo.Orders_Clean o ON o.OrderID = oi.OrderID
WHERE o.OrderID IS NULL;

SELECT oi.OrderItemID, oi.ProductID
FROM dbo.Order_Items_Clean oi
LEFT JOIN dbo.Products_Clean p ON p.ProductID = oi.ProductID
WHERE p.ProductID IS NULL;

SELECT r.ReturnID, r.OrderID
FROM dbo.Return_Clean r
LEFT JOIN dbo.Orders_Clean o ON o.OrderID = r.OrderID
WHERE o.OrderID IS NULL;

SELECT r.ReturnID, r.ProductID
FROM dbo.Return_Clean r
LEFT JOIN dbo.Products_Clean p ON p.ProductID = r.ProductID
WHERE p.ProductID IS NULL;

-- 1d. Quantity values that are not whole numbers (would be truncated to INT)
SELECT OrderItemID, Quantity FROM dbo.Order_Items_Clean WHERE Quantity <> FLOOR(Quantity);
SELECT ProductID, StockQuantity FROM dbo.Products_Clean WHERE StockQuantity <> FLOOR(StockQuantity);
GO


/* ---------------------------------------------------------------------
   STEP 2: CREATE TABLES (parents first)
   --------------------------------------------------------------------- */

CREATE TABLE dbo.Customers (
    CustomerID       NVARCHAR(50)   NOT NULL,
    CustomerName     NVARCHAR(255)  NULL,
    Email            NVARCHAR(255)  NULL,
    Phone            NVARCHAR(50)   NULL,
    Gender           NVARCHAR(20)   NULL,
    DateOfBirth      DATE           NULL,
    SignupDate       DATE           NULL,
    City             NVARCHAR(100)  NULL,
    State            NVARCHAR(100)  NULL,
    Country          NVARCHAR(100)  NULL,
    CustomerSegment  NVARCHAR(100)  NULL,
    CONSTRAINT PK_Customers PRIMARY KEY CLUSTERED (CustomerID)
);
GO

CREATE TABLE dbo.Products (
    ProductID      NVARCHAR(50)   NOT NULL,
    ProductName    NVARCHAR(255)  NULL,
    Category       NVARCHAR(100)  NULL,
    SubCategory    NVARCHAR(100)  NULL,
    Brand          NVARCHAR(100)  NULL,
    UnitPrice      DECIMAL(12,2)  NULL,
    CostPrice      DECIMAL(12,2)  NULL,
    StockQuantity  INT            NULL,
    CONSTRAINT PK_Products PRIMARY KEY CLUSTERED (ProductID)
);
GO

CREATE TABLE dbo.Orders (
    OrderID                NVARCHAR(50)   NOT NULL,
    CustomerID             NVARCHAR(50)   NOT NULL,
    OrderDate              DATE           NULL,
    ShipDate               DATE           NULL,
    DeliveryDate           DATE           NULL,
    DataValidation         NVARCHAR(255)  NULL,
    Channel                NVARCHAR(100)  NULL,
    PaymentMode            NVARCHAR(100)  NULL,
    Region                 NVARCHAR(100)  NULL,
    State                  NVARCHAR(100)  NULL,
    OrderStatus            NVARCHAR(100)  NULL,
    CalculatedOrderStatus  NVARCHAR(255)  NULL,
    ShippingCost           DECIMAL(12,2)  NULL,
    CONSTRAINT PK_Orders PRIMARY KEY CLUSTERED (OrderID),
    CONSTRAINT FK_Orders_Customers
        FOREIGN KEY (CustomerID) REFERENCES dbo.Customers (CustomerID)
);
GO

CREATE TABLE dbo.Order_Items (
    OrderItemID      NVARCHAR(50)   NOT NULL,
    OrderID          NVARCHAR(50)   NOT NULL,
    ProductID        NVARCHAR(50)   NOT NULL,
    Quantity         INT            NULL,
    UnitPriceAtSale  DECIMAL(12,2)  NULL,
    Discount         DECIMAL(9,4)   NULL,
    LineTotal        DECIMAL(14,2)  NULL,
    CONSTRAINT PK_Order_Items PRIMARY KEY CLUSTERED (OrderItemID),
    CONSTRAINT FK_OrderItems_Orders
        FOREIGN KEY (OrderID)   REFERENCES dbo.Orders (OrderID),
    CONSTRAINT FK_OrderItems_Products
        FOREIGN KEY (ProductID) REFERENCES dbo.Products (ProductID)
);
GO

CREATE TABLE dbo.Returns (
    ReturnID         NVARCHAR(50)   NOT NULL,
    OrderID          NVARCHAR(50)   NOT NULL,
    ProductID        NVARCHAR(50)   NOT NULL,
    ReturnDateClean  DATETIME       NULL,
    ReturnReason     NVARCHAR(255)  NULL,
    RefundAmount     DECIMAL(12,2)  NULL,
    CONSTRAINT PK_Returns PRIMARY KEY CLUSTERED (ReturnID),
    CONSTRAINT FK_Returns_Orders
        FOREIGN KEY (OrderID)   REFERENCES dbo.Orders (OrderID),
    CONSTRAINT FK_Returns_Products
        FOREIGN KEY (ProductID) REFERENCES dbo.Products (ProductID)
);
GO


/* ---------------------------------------------------------------------
   STEP 3: SUPPORTING INDEXES (foreign-key lookup paths)
   --------------------------------------------------------------------- */
CREATE NONCLUSTERED INDEX IX_Orders_CustomerID     ON dbo.Orders      (CustomerID);
CREATE NONCLUSTERED INDEX IX_Orders_OrderDate      ON dbo.Orders      (OrderDate);
CREATE NONCLUSTERED INDEX IX_OrderItems_OrderID    ON dbo.Order_Items (OrderID);
CREATE NONCLUSTERED INDEX IX_OrderItems_ProductID  ON dbo.Order_Items (ProductID);
CREATE NONCLUSTERED INDEX IX_Returns_OrderID       ON dbo.Returns     (OrderID);
CREATE NONCLUSTERED INDEX IX_Returns_ProductID     ON dbo.Returns     (ProductID);
GO


/* ---------------------------------------------------------------------
   STEP 4: LOAD DATA (parents before children, all-or-nothing)
   TRY_CAST turns un-castable values into NULL instead of failing;
   check STEP 5 counts if you expect every value to convert.
   --------------------------------------------------------------------- */
SET XACT_ABORT ON;
BEGIN TRY
    BEGIN TRANSACTION;

    INSERT INTO dbo.Customers
        (CustomerID, CustomerName, Email, Phone, Gender, DateOfBirth,
         SignupDate, City, State, Country, CustomerSegment)
    SELECT customerid, customername, email, phone, gender, dateofbirth,
           signupdate, city, state, country, customersegment
    FROM dbo.Customers_Clean;

    INSERT INTO dbo.Products
        (ProductID, ProductName, Category, SubCategory, Brand,
         UnitPrice, CostPrice, StockQuantity)
    SELECT ProductID, ProductName, Category, SubCategory, Brand,
           TRY_CAST(UnitPrice AS DECIMAL(12,2)),
           TRY_CAST(CostPrice AS DECIMAL(12,2)),
           TRY_CAST(StockQuantity AS INT)
    FROM dbo.Products_Clean;

    INSERT INTO dbo.Orders
        (OrderID, CustomerID, OrderDate, ShipDate, DeliveryDate, DataValidation,
         Channel, PaymentMode, Region, State, OrderStatus,
         CalculatedOrderStatus, ShippingCost)
    SELECT OrderID, CustomerID, OrderDate, ShipDate, DeliveryDate, DataValidation,
           Channel, PaymentMode, Region, State, OrderStatus,
           CalculatedOrderStatus,
           TRY_CAST(ShippingCost AS DECIMAL(12,2))
    FROM dbo.Orders_Clean;

    INSERT INTO dbo.Order_Items
        (OrderItemID, OrderID, ProductID, Quantity,
         UnitPriceAtSale, Discount, LineTotal)
    SELECT OrderItemID, OrderID, ProductID,
           TRY_CAST(Quantity AS INT),
           TRY_CAST(UnitPriceAtSale AS DECIMAL(12,2)),
           TRY_CAST(Discount AS DECIMAL(9,4)),
           TRY_CAST(LineTotal AS DECIMAL(14,2))
    FROM dbo.Order_Items_Clean;

    INSERT INTO dbo.Returns
        (ReturnID, OrderID, ProductID, ReturnDateClean,
         ReturnReason, RefundAmount)
    SELECT ReturnID, OrderID, ProductID, ReturnDateClean,
           ReturnReason,
           TRY_CAST(RefundAmount AS DECIMAL(12,2))
    FROM dbo.Return_Clean;

    COMMIT TRANSACTION;
    PRINT 'Load complete.';
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    PRINT 'Load FAILED and was rolled back: ' + ERROR_MESSAGE();
    THROW;
END CATCH;
GO


/* ---------------------------------------------------------------------
   STEP 5: VERIFY (source and target counts should match)
   --------------------------------------------------------------------- */
SELECT 'Customers'   AS tbl, (SELECT COUNT(*) FROM dbo.Customers_Clean)   AS source_rows, (SELECT COUNT(*) FROM dbo.Customers)   AS target_rows
UNION ALL SELECT 'Products',    (SELECT COUNT(*) FROM dbo.Products_Clean),    (SELECT COUNT(*) FROM dbo.Products)
UNION ALL SELECT 'Orders',      (SELECT COUNT(*) FROM dbo.Orders_Clean),      (SELECT COUNT(*) FROM dbo.Orders)
UNION ALL SELECT 'Order_Items', (SELECT COUNT(*) FROM dbo.Order_Items_Clean), (SELECT COUNT(*) FROM dbo.Order_Items)
UNION ALL SELECT 'Returns',     (SELECT COUNT(*) FROM dbo.Return_Clean),      (SELECT COUNT(*) FROM dbo.Returns);

-- Values that became NULL because they could not be converted (expect 0 each)
SELECT COUNT(*) AS lost_unitprice
FROM dbo.Products_Clean s JOIN dbo.Products t ON t.ProductID = s.ProductID
WHERE s.UnitPrice IS NOT NULL AND t.UnitPrice IS NULL;

SELECT COUNT(*) AS lost_linetotal
FROM dbo.Order_Items_Clean s JOIN dbo.Order_Items t ON t.OrderItemID = s.OrderItemID
WHERE s.LineTotal IS NOT NULL AND t.LineTotal IS NULL;

-- Money reconciliation (small rounding differences are expected)
SELECT (SELECT SUM(LineTotal) FROM dbo.Order_Items_Clean) AS source_total,
       (SELECT SUM(LineTotal) FROM dbo.Order_Items)       AS target_total;
GO


/* ---------------------------------------------------------------------
   STEP 6 (OPTIONAL): ROLLBACK / CLEANUP. Drops the new tables only.
   The original _Clean tables are never modified by this script.
   --------------------------------------------------------------------- */
-- DROP TABLE dbo.Returns;
-- DROP TABLE dbo.Order_Items;
-- DROP TABLE dbo.Orders;
-- DROP TABLE dbo.Products;
-- DROP TABLE dbo.Customers;
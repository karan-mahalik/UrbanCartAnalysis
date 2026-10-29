/*
URBANCART — PROPOSED MODEL ONLY, NOT THE ORIGINAL SOURCE CONTRACT.
This is commented documentation and intentionally non-executable.
Customers(CustomerID nvarchar(64), CustomerName nvarchar(200), Region nvarchar(100))
Products(ProductID nvarchar(64), ProductName nvarchar(200), Category nvarchar(100))
Orders(OrderID nvarchar(64), CustomerID nvarchar(64), OrderDate date,
       Channel nvarchar(80), Region nvarchar(100),
       PaymentMethod nvarchar(80), ShippedDate date NULL, DeliveredDate date NULL)
OrderItems(OrderItemID nvarchar(64), OrderID nvarchar(64), ProductID nvarchar(64),
           Quantity int, UnitPrice decimal(18,2))
Returns(ReturnID nvarchar(64), OrderID nvarchar(64), ProductID nvarchar(64),
        ReturnDate date)
Proposed gross sales = Quantity * UnitPrice. Confirm discount/tax/refund rules,
return grain, all relationship keys and date data types before implementation.
*/

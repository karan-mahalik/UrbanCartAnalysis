# UrbanCart — illustrative DAX measures

**Not original submitted DAX.** These measures assume proposed `Orders`, `OrderItems` and `Returns` tables with valid relationships and corresponding keys. Confirm actual model and grain first.

```dax
Gross Sales =
SUMX ( OrderItems, OrderItems[Quantity] * OrderItems[UnitPrice] )

Order Count =
DISTINCTCOUNT ( Orders[OrderID] )

Average Order Value =
DIVIDE ( [Gross Sales], [Order Count] )

Orders With Returns =
DISTINCTCOUNT ( Returns[OrderID] )

Order Return Rate =
DIVIDE ( [Orders With Returns], [Order Count] )
```

Under some models, `Returns` may include orphaned order IDs; verify with SQL, relationships and filters. The business meaning of gross vs net sales, customer repeat rate, returns at order versus item grain and delivery timing must be confirmed before publishing values. No PBIX or DAX execution has been performed.

# Analytics pipeline — UrbanCart

The flow below is an **intended architecture only**, pending original dataset/Power BI uploads and runtime review.

```mermaid
flowchart LR
    A[Raw Orders, Items, Customers, Products, Returns] --> B[Data-quality audit and documented cleaning]
    B --> C[Proposed SQL Server relational model]
    C --> D[Reporting queries and window calculations]
    D --> E[Power BI semantic model and two-page report]
    E --> F[Reconciled KPIs and verified findings]
```

**Relationships to verify:** Customers→Orders, Orders→OrderItems, Products→OrderItems, Returns→Orders/Items. Verify source record grain, key uniqueness, orphan records, returns and refund policy. Read [schema contract](../sql/01_schema_contract.sql), [metrics](METRICS.md), and [quality log](DATA_QUALITY.md).

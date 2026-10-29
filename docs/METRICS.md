# Business metrics — definitions proposed for verification

Original project files and measured results are pending. Reconcile these tentative definitions with the actual source and Power BI report.

| Metric | Proposed definition | Caveat |
| --- | --- | --- |
| Gross sales | Sum of eligible Quantity × UnitPrice | Excludes unspecified shipping/tax/refunds |
| Orders | Distinct eligible order IDs | Same included population across visuals |
| AOV | Gross sales / distinct orders | Gross not net |
| Revenue by channel/region | Gross sales grouped through valid order relationships | No double counting |
| Repeat customers | Distinct customers with 2+ orders during chosen period | Declare time window |
| Return rate (order) | Distinct orders with return / distinct total orders | Distinct from unit return rate |
| Delivery duration | DeliveredDate - ShippedDate for valid rows | Exclude missing/reversed dates |
| Monthly growth | (current gross sales - previous gross sales)/previous gross sales | Missing months need separate logic |

Record actual row counts, anomaly handling, reconciliation outcomes and source citations before publishing any numerical insight.

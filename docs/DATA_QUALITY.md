# Data-quality review checklist

No dataset has been uploaded or profiled. Record results here after examining real files.

| Check | Procedure / decision needed | Status |
| --- | --- | --- |
| Source rights and privacy | Confirm source licensing; remove personal/client records | Pending |
| Key uniqueness | Evaluate distinct keys, duplicates and transaction grain | Pending |
| Missing values | Profile nulls and blank strings in IDs, dates, prices | Pending |
| Datatypes | Parse currency and locale-dependent dates carefully | Pending |
| Relationships | Check orphaned records and accidental many-to-many joins | Pending |
| Monetary calculations | Confirm tax, discounts, shipping, returns and refunds | Pending |
| Time periods | Confirm timezone, date range and period filters | Pending |
| Reconciliation | Compare cleaned rows, SQL outputs and report measures | Pending |

Do not silently delete anomalies; document each rule and count before and after transformation.


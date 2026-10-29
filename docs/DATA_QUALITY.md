# Data-quality checklist — actual source files present

Uploaded datasets are now present, but **no comprehensive file-content or personal-data audit has been performed**. Original SQL source has been inspected at a text level only; its analytical results have not been executed or reconciled.

| Check | Action | Status |
| --- | --- | --- |
| Public-sharing permissions | Confirm the right to publish each uploaded file | Pending |
| Sensitive information | Check customer names, emails, phones, or private data | Pending |
| Rows/field types | Profile actual dataset, sheet names, currency/date formats | Pending |
| Primary/foreign key uniqueness | Check duplicates, orphans, grain | Pending |
| Cleaning evidence | Record row count differences and transformation rules | Pending |
| Financial business logic | Review discounts, returns, tax, cancellations and exclusions | Pending |
| SQL execution | Review potentially destructive statements, run in dev | Pending |
| Power BI validation | Refresh original PBIX and reconcile KPIs | Pending |

See [source review](ORIGINAL_SOURCE_REVIEW.md) and [manifest](ASSET_MANIFEST.md). Do not silently delete anomalies or report guessed results.

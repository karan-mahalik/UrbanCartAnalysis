# Original uploaded source: initial static review

This is a **read-only text/metadata review**, not a successful SQL or Power BI run.

The uploaded `sql/UrbanCartDataModelling.sql` includes schema creation, loads and **DELETE/ROLLBACK/COMMIT** statements: inspect and execute only carefully selected sections in a disposable database. `sql/UrbanCartAnalysis.sql` includes SQL Server views and an `UPDATE Orders` transaction. The package's `docs/README.txt` mentions PostgreSQL/MySQL/SQLite, but the uploaded scripts contain **T-SQL-specific syntax**; treat SQL Server as the demonstrated dialect. No script was modified or executed.

## Files used as evidence

- [sql/UrbanCartDataModelling.sql](../sql/UrbanCartDataModelling.sql) — Uploaded SQL Server schema/load script
- [sql/UrbanCartAnalysis.sql](../sql/UrbanCartAnalysis.sql) — Uploaded SQL Server analysis/views script
- [data/raw/UrbanCart_Raw_Sales_Data.xlsx](../data/raw/UrbanCart_Raw_Sales_Data.xlsx) — Raw workbook
- [data/cleaned/UrbanCart_Cleaned_Sales_Data.xlsx](../data/cleaned/UrbanCart_Cleaned_Sales_Data.xlsx) — Cleaned workbook
- [powerbi/UrbanCartDashboardPresntation.pbix](../powerbi/UrbanCartDashboardPresntation.pbix) — Uploaded Power BI report (original spelling kept)

## Next QA steps

- Confirm source ownership, permission to publish and presence of any personal or client records.
- Inspect workbook sheets and/or CSV field names, row counts, duplicates and types.
- Review original SQL for destructive statements and metric-grain errors before running it on a **development** database.
- Open/refresh the uploaded PBIX in Power BI Desktop using appropriate data connections.
- Reconcile business KPIs across dataset, SQL and dashboard; record verified findings.

**No uploaded binary or SQL source bytes were changed by the folder reorganization.**

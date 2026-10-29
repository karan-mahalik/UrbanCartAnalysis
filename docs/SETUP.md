# Setup and reproduction plan — UrbanCart Sales & Customer Analytics

**Inputs now available:** see [asset manifest](ASSET_MANIFEST.md). **None of the uploaded SQL/PBIX files has been runtime-validated here.**

1. Review both Excel workbooks for provenance, personal data, sheet names, duplicates and transformations; confirm redistribution rights.
2. Use a **new, disposable SQL Server database**. Open `sql/UrbanCartDataModelling.sql` and inspect each step, especially its `DELETE`, transaction and `CREATE TABLE` statements. Do not execute the entire script blindly.
3. Only after verified staging, carefully review `sql/UrbanCartAnalysis.sql` for SQL Server queries, views and the `UPDATE Orders` transaction.
4. The `sql/01_schema_contract.sql` and `sql/02_analysis_queries.sql` files were earlier **illustrative** and do not supersede the uploaded source schema or source code.
5. Open the original `powerbi/UrbanCartDashboardPresntation.pbix` in Power BI Desktop, inspect model/DAX, update connections and test refresh.
6. Compare the SQL outputs with Power BI totals and record actual findings only after successful verification. `docs/UrbanCart_Dashboard_Reference.html` is a separately supplied reference, not itself proof of PBIX output.

## Static validation
```bash
python scripts/validate_repository.py
```

The script checks required paths, zero-byte files, and simple relative Markdown links; it **does not run SQL Server or Power BI**, audit spreadsheet contents, or assert any measured KPI.

# Setup and verification boundaries

Project: **UrbanCart Sales & Customer Analytics**

## Expected environment
- SQL Server + SSMS for T-SQL
- Power BI Desktop for the real PBIX file
- Excel or Power Query for source profiling
- Python 3.11+ for the static repository validator (standard library only)

## Steps
1. Review [source and permissions](ASSET_MANIFEST.md) before publishing data.
2. Inspect source column names, date parsing, primary keys, cardinality and currency conventions.
3. Compare verified fields with [proposed SQL model](../sql/01_schema_contract.sql). Adapt examples to real data instead of changing source to fit the example.
4. Import to a new **development** SQL Server database, not a production database. Review each statement before executing.
5. Run relevant T-SQL. Reconcile row counts and KPI definitions with source.
6. Open original PBIX in Power BI Desktop, review data connections, refresh, validate measures and capture screenshots only from real reports.
7. Update [evidence](PROJECT_EVIDENCE.md), [metrics](METRICS.md), and [quality log](DATA_QUALITY.md).

## Static check
```bash
python scripts/validate_repository.py
```

GitHub Actions runs the same structure check. **It does not execute SQL Server, DAX, Power BI Desktop or validate numeric results.**


# SQL Server — original files and illustrative starters

## Original uploaded SQL

- [UrbanCartDataModelling.sql](UrbanCartDataModelling.sql) — Uploaded SQL Server schema/load script
- [UrbanCartAnalysis.sql](UrbanCartAnalysis.sql) — Uploaded SQL Server analysis/views script

## Previously prepared examples

- [01_schema_contract.sql](01_schema_contract.sql) — **proposed** schema; not extracted from source.
- [02_analysis_queries.sql](02_analysis_queries.sql) — **illustrative**, read-only example queries; not the uploaded original.
- These examples must be adapted if used; original source structures take priority.

## Safety and execution

The uploaded `sql/UrbanCartDataModelling.sql` includes schema creation, loads and **DELETE/ROLLBACK/COMMIT** statements: inspect and execute only carefully selected sections in a disposable database. `sql/UrbanCartAnalysis.sql` includes SQL Server views and an `UPDATE Orders` transaction. The package's `docs/README.txt` mentions PostgreSQL/MySQL/SQLite, but the uploaded scripts contain **T-SQL-specific syntax**; treat SQL Server as the demonstrated dialect. No script was modified or executed.

Use a disposable, isolated SQL Server database. Inspect each script before execution. This repository's GitHub Actions only checks file structure and links, **not** T-SQL syntax or runtime results. See [setup](../docs/SETUP.md).

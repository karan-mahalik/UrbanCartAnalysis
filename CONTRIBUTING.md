# Contributing and verification

1. Use a descriptive branch and explain each source/document change.
2. Preserve authentic raw data and original project files; add cleaned or documented derivatives separately.
3. Never commit secrets or client/customer personal information.
4. Document schema changes and reconcile SQL/DAX calculations with real sources.
5. Run `python scripts/validate_repository.py` before proposing a merge. This is only a static check.
6. Do not mark SQL Server/Power BI validation as successful without actual execution and evidence.

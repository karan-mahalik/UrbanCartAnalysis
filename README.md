# UrbanCart Sales & Customer Analytics

**🌐 Professional portfolio:** [Karan Mahalik — Data Analyst & Power BI Developer](https://karan-mahalik-portfolio.vercel.app/)

**Excel · SQL Server · T-SQL · Power BI · DAX**

Karan Mahalik's analytics project, now organized with its **uploaded source assets**, supporting materials, and independently authored documentation.

> **Status:** Uploaded datasets/workbooks, original SQL scripts and actual Power BI report files have been organized. **SQL Server execution, source/data privacy review, numeric reconciliation and Power BI Desktop refresh have not been completed.** Previously prepared starter SQL/DAX remains explicitly illustrative.

## Uploaded project files

| Area | Uploaded file | Purpose |
| --- | --- | --- |
| Data | [UrbanCart_Raw_Sales_Data.xlsx](data/raw/UrbanCart_Raw_Sales_Data.xlsx) | Raw workbook |
| Data | [UrbanCart_Cleaned_Sales_Data.xlsx](data/cleaned/UrbanCart_Cleaned_Sales_Data.xlsx) | Cleaned workbook |
| SQL Server | [UrbanCartDataModelling.sql](sql/UrbanCartDataModelling.sql) | Uploaded SQL Server schema/load script |
| SQL Server | [UrbanCartAnalysis.sql](sql/UrbanCartAnalysis.sql) | Uploaded SQL Server analysis/views script |
| Power BI | [UrbanCartDashboardPresntation.pbix](powerbi/UrbanCartDashboardPresntation.pbix) | Uploaded Power BI report (original spelling kept) |
| Documentation | [UrbanCart_Business_Requirement_Document.docx](docs/UrbanCart_Business_Requirement_Document.docx) | Business requirements |
| Documentation | [UrbanCart_Project_Walkthrough.pptx](docs/UrbanCart_Project_Walkthrough.pptx) | Project walkthrough |
| Documentation | [UrbanCart_Dashboard_Reference.html](docs/UrbanCart_Dashboard_Reference.html) | HTML dashboard reference |
| Documentation | [README.txt](docs/README.txt) | Original uploaded package notes |

## Business scope

Revenue by time period, channel and geography; product performance; customer segments and repeat purchasing; returns, delivery timing and payment methods.

The scope is consistent with the supplied resume and supporting project materials. **No numerical result is asserted without executing and reconciling the original files.**

## How to reproduce and verify

See [Setup](docs/SETUP.md), [source-file review](docs/ORIGINAL_SOURCE_REVIEW.md), [data-quality checklist](docs/DATA_QUALITY.md) and [metric definitions](docs/METRICS.md). Do not execute SQL against production databases or assume the original PBIX refreshes successfully.

## Project structure

- [data/](data/README.md) — raw, cleaned and/or reference files
- [sql/](sql/README.md) — uploaded original SQL, plus *separately labeled illustrative starter SQL*
- [powerbi/](powerbi/README.md) — uploaded original PBIX; DAX examples are *not extracted from it*
- [docs/](docs/SETUP.md) — BRD/presentation/reference, [manifest](docs/ASSET_MANIFEST.md), validation and architecture
- [assets/](assets/README.md) — genuine screenshot location (no verified dashboard captures yet)
- [scripts/validate_repository.py](scripts/validate_repository.py) — static file/link check run by [GitHub Actions](.github/workflows/validate.yml)

## Important limitation

GitHub Actions validates **repository structure and simple relative Markdown links only**. It does not execute T-SQL, open Excel datasets for analytical QA, refresh Power BI, verify DAX calculations or perform a comprehensive secret/privacy scan.

**Maintained by:** [Karan Mahalik](https://github.com/karan-mahalik) · [LinkedIn](https://www.linkedin.com/in/karan-mahalik-122438369/)

# UrbanCart Sales & Customer Analytics

**Excel · SQL Server · T-SQL · Power BI · DAX**

An e-commerce analytics case study based on the UrbanCart project described in Karan Mahalik's resume. It focuses on sales trends, customers, products, returns, channels, payment and delivery reporting.

> **Status: framework prepared; original project files pending upload.** The source/cleaned workbooks, original SQL scripts, Power BI `.pbix`, screenshots and validated results have not been provided. Proposed SQL/DAX files are **illustrative only** and must be reconciled with the actual source.

## Business questions
- How does revenue change across months, quarters, years, sales channels and geography?
- What products and categories lead or lag, and how does performance change over time?
- What are repeat-purchase and return patterns?
- How do payment methods and delivery metrics vary?

## Repository layout
| Folder | Purpose |
| --- | --- |
| [data/](data/README.md) | Raw/cleaned authorized files and source data dictionary |
| [sql/](sql/README.md) | Proposed entities and read-only T-SQL starter queries |
| [powerbi/](powerbi/README.md) | Original report upload location and proposed DAX |
| [docs/](docs/SETUP.md) | Setup, metrics, data-quality and verification notes |
| [scripts/](scripts/validate_repository.py) | Static structure checks, not runtime testing |

## Work documented in the resume
Checks for missing/inconsistent data across orders, order items, customers, products and returns; revenue by time, channel and region; SQL views, rankings and running totals; customer frequency, returns, payments and deliveries; and a two-page Power BI report. These descriptions come from the **supplied resume**, not re-executed code or dashboards.

## How to complete the project
1. Upload the authentic files to [data/raw/](data/raw/README.md), [data/cleaned/](data/cleaned/README.md), [sql/](sql/README.md) and [powerbi/](powerbi/README.md).
2. Document source, permissions, row counts and field definitions in [asset manifest](docs/ASSET_MANIFEST.md).
3. Reconcile the proposed schema and analysis with the actual datasets.
4. Run `python scripts/validate_repository.py` for static checks.
5. Validate SQL Server query results and Power BI report refresh independently; then add verified findings and screenshots.

[Metrics](docs/METRICS.md) · [Data quality](docs/DATA_QUALITY.md) · [Project evidence](docs/PROJECT_EVIDENCE.md)

**Author:** [Karan Mahalik](https://github.com/karan-mahalik) · [LinkedIn](https://www.linkedin.com/in/karan-mahalik-122438369/)

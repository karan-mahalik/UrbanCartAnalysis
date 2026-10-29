UrbanCart Analytics — Portfolio Project Package
================================================
A fresher-to-1-YOE data analyst project: Excel (cleaning) -> SQL (analysis) -> Power BI (dashboard).

WHAT'S IN THIS ZIP
-------------------
1. UrbanCart_Raw_Sales_Data.xlsx
   The raw, intentionally messy dataset (~34,600 rows across 5 tables: Customers,
   Products, Orders, Order_Items, Returns). Includes a README tab, a data
   dictionary, and a Data Cleaning Log template. Start here — clean this in Excel.

2. UrbanCart_Business_Requirement_Document.docx
   The full BRD: background, objectives, scope, stakeholders, data sources,
   functional & non-functional requirements for each phase (Excel/SQL/Power BI),
   deliverables, success metrics, timeline, and acceptance criteria.

3. UrbanCart_Project_Walkthrough.pptx
   A 15-slide deck walking through the end-to-end approach: why the project,
   the dataset, the Excel cleaning plan, SQL business questions, the Power BI
   data model and dashboard pages, a suggested 4-week timeline, and resume /
   interview talking points.

4. UrbanCart_Dashboard_Reference.html
   An interactive, Power BI-style dashboard built from the real (cleaned)
   dataset, with working cross-filters (Region / Channel / Segment), a KPI
   strip, revenue trend, category/region/channel/segment breakdowns, top
   products, and return reasons. Open this file in any browser — use it as
   the visual reference for building the actual Power BI dashboard.
   (A live, shareable version is also available if this was sent with a link.)

HOW TO USE THIS PACKAGE
------------------------
1. Open the raw workbook in Excel. Follow the README tab there, clean each
   table, and keep the Data Cleaning Log updated as you go — this is one of
   the most common interview discussion points.
2. Load your cleaned tables into a SQL database (PostgreSQL, MySQL, or
   SQLite all work) and write the analysis queries listed in the BRD and the
   deck (revenue trends, regional/category performance, return rates,
   customer segment behavior, etc).
3. Open the dashboard reference in a browser to study the layout, KPI
   choices, color system, and interactivity — then rebuild it in Power BI
   Desktop using the data model described in the deck (star schema: Orders /
   Order_Items as facts; Customers, Products, Date as dimensions).
4. Use the deck as your presentation when walking an interviewer through the
   project, and the BRD as your supporting documentation.

Suggested pace: ~4 weeks part-time (1 week per phase, 1 week to polish and
rehearse). See the BRD's Suggested Timeline section for details.

Good luck — build it, explain it, ship it.

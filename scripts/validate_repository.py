#!/usr/bin/env python3
"""Static repository/documentation check; no SQL Server or Power BI execution."""
from pathlib import Path
import re
import sys

root = Path(__file__).resolve().parents[1]
required = [
    "README.md", ".gitignore", ".github/workflows/validate.yml",
    "data/README.md", "data/raw/README.md", "data/cleaned/README.md",
    "sql/README.md", "sql/01_schema_contract.sql", "sql/02_analysis_queries.sql",
    "powerbi/README.md", "powerbi/DAX_MEASURES.md",
    "docs/SETUP.md", "docs/UPLOAD_GUIDE.md", "docs/ASSET_MANIFEST.md",
    "docs/PROJECT_EVIDENCE.md", "docs/DATA_QUALITY.md", "docs/METRICS.md",
    "docs/REPORT_GUIDE.md", "docs/ROADMAP.md", "scripts/validate_repository.py",
]
issues = []
for rel in required:
    p = root / rel
    if not p.is_file() or not p.stat().st_size:
        issues.append(f"Missing or empty required file: {rel}")
for p in root.rglob("*"):
    if not p.is_file() or ".git" in p.parts:
        continue
    rel = p.relative_to(root).as_posix()
    if p.stat().st_size == 0:
        issues.append(f"Empty file: {rel}")
    if p.name == ".env" or (p.name.startswith(".env.") and p.name != ".env.example"):
        issues.append(f"Possible exposed .env file: {rel}")
    if p.suffix.lower() in {".pem", ".key", ".p12", ".pfx"}:
        issues.append(f"Possible private key/certificate: {rel}")
    if p.suffix.lower() != ".md":
        continue
    body = p.read_text(encoding="utf-8")
    for link in re.findall(r"\[[^\]]+\]\(([^)]+)\)", body):
        if link.startswith(("http:", "https:", "mailto:", "#")) or " " in link:
            continue
        target = link.split("#", 1)[0].split("?", 1)[0]
        if target and not (p.parent / target).exists():
            issues.append(f"Broken relative link {rel}: {link}")
if issues:
    print("Static validation FAILED:")
    for issue in issues:
        print(" -", issue)
    sys.exit(1)
print("Static structure and simple Markdown link validation passed.")
print("SQL Server, DAX, Power BI Desktop, external URLs, data correctness and security were NOT runtime-tested.")


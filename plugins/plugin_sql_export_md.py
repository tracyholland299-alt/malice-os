import sqlite3, os
db_path = os.path.expanduser("~/ScrapeForge/output/autonomous/autonomous.db")
out_path = os.path.expanduser("~/ScrapeForge/export/harvest.md")
conn = sqlite3.connect(db_path)
cursor = conn.execute("SELECT * FROM harvest")
with open(out_path, "w") as f:
    f.write("| Source | Title | URL | Category | Timestamp |\\n")
    f.write("|--------|-------|-----|----------|-----------|\\n")
    for row in cursor:
        f.write("| " + " | ".join(row) + " |\\n")
conn.close(); print("📄 SQL → Markdown export complete.")

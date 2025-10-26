import sqlite3, json, os
db_path = os.path.expanduser("~/ScrapeForge/output/autonomous/autonomous.db")
out_path = os.path.expanduser("~/ScrapeForge/export/harvest.json")
conn = sqlite3.connect(db_path)
cursor = conn.execute("SELECT * FROM harvest")
rows = [dict(zip([col[0] for col in cursor.description], row)) for row in cursor]
with open(out_path, "w") as f: json.dump(rows, f, indent=2)
conn.close(); print("📤 SQL → JSON export complete.")

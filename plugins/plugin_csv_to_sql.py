import csv, sqlite3, os
db_path = os.path.expanduser("~/ScrapeForge/output/autonomous/autonomous.db")
csv_path = os.path.expanduser("~/ScrapeForge/export/harvest.csv")
conn = sqlite3.connect(db_path)
with open(csv_path) as f:
    reader = csv.DictReader(f)
    for row in reader:
        conn.execute("INSERT INTO harvest VALUES (?, ?, ?, ?, ?)", (
            row["source"], row["title"], row["url"], row["category"], row["timestamp"]
        ))
conn.commit(); conn.close()
print("✅ CSV → SQL ingest complete.")

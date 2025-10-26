import sqlite3, os
db_path = os.path.expanduser("~/ScrapeForge/output/autonomous/autonomous.db")
conn = sqlite3.connect(db_path)
conn.execute("INSERT INTO harvest VALUES (?, ?, ?, ?, ?)", (
    "sql_ingest",
    "SQL Title",
    "http://sql.com",
    "data",
    "2025-10-25"
))
conn.commit()
conn.close()
print("✅ SQL ingest complete.")

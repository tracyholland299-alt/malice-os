import sqlite3, os
db_path = os.path.expanduser("~/ScrapeForge/output/autonomous/autonomous.db")
conn = sqlite3.connect(db_path)
cursor = conn.execute("SELECT category, COUNT(*) FROM harvest GROUP BY category")
print("📊 Category Counts:")
for row in cursor: print(f" - {row[0]}: {row[1]}")
conn.close()

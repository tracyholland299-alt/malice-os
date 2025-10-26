import sqlite3, os
db_path = os.path.expanduser("~/ScrapeForge/output/autonomous/autonomous.db")
conn = sqlite3.connect(db_path)
conn.execute("ALTER TABLE harvest ADD COLUMN severity TEXT")
cursor = conn.execute("SELECT rowid, category FROM harvest")
for row in cursor:
    severity = "high" if row[1] == "data" else "low"
    conn.execute("UPDATE harvest SET severity=? WHERE rowid=?", (severity, row[0]))
conn.commit(); conn.close()
print("🚨 Threat classification complete.")

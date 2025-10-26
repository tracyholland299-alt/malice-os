import sqlite3, os
db = os.path.expanduser("~/ScrapeForge/output/autonomous/autonomous.db")
conn = sqlite3.connect(db)
cursor = conn.execute("SELECT content FROM ai_seed ORDER BY timestamp DESC LIMIT 5")
summary = "🧠 Summary:\n" + "\n".join([row[0][:100] + "..." for row in cursor.fetchall()])
print(summary)
conn.close()


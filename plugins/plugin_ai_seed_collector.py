import sqlite3, os, time

db = os.path.expanduser("~/ScrapeForge/output/autonomous/autonomous.db")
conn = sqlite3.connect(db)
cursor = conn.execute("SELECT url, title FROM harvest WHERE category IN ('live', 'data')")
rows = cursor.fetchall()

for url, title in rows:
    conn.execute("INSERT INTO ai_seed VALUES (?, ?, ?, ?)", ("ai_seed_collector", title, "text", time.strftime("%Y-%m-%d")))

conn.commit()
conn.close()
print(f"🧠 Seeded {len(rows)} entries into ai_seed.")


import sqlite3, os

db = os.path.expanduser("~/ScrapeForge/output/autonomous/autonomous.db")
conn = sqlite3.connect(db)
cursor = conn.cursor()

# Ensure harvest table exists
cursor.execute("""
CREATE TABLE IF NOT EXISTS harvest (
    source TEXT,
    title TEXT,
    url TEXT,
    category TEXT,
    timestamp TEXT,
    severity TEXT
)
""")

# Ensure ai_seed table exists
cursor.execute("""
CREATE TABLE IF NOT EXISTS ai_seed (
    source TEXT,
    content TEXT,
    type TEXT,
    timestamp TEXT
)
""")

conn.commit()
conn.close()
print("🧠 Database schema validated.")

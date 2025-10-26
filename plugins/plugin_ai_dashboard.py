import sqlite3, os
db = os.path.expanduser("~/ScrapeForge/output/autonomous/autonomous.db")
conn = sqlite3.connect(db)
cursor = conn.execute("SELECT COUNT(*) FROM ai_seed")
seed_count = cursor.fetchone()[0]
cursor = conn.execute("SELECT COUNT(*) FROM harvest WHERE severity=\"high\"")
high_sev = cursor.fetchone()[0]
print(f"""
╔════════════════════════════╗
║   MALICE.OS™ AI Dashboard  ║
╠════════════════════════════╣
║ 🧠 AI Seeds:     {seed_count:<6}       ║
║ 🔥 High Severity: {high_sev:<6}       ║
╚════════════════════════════╝
""")
conn.close()


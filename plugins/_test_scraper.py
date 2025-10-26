import sqlite3, os, time
db = os.path.expanduser("/root/ScrapeForge/output/autonomous/autonomous.db")
conn = sqlite3.connect(db)

entries = [
    ("test_source", "AI breakthrough in Linux automation", "https://example.com/ai-linux", "live", time.strftime("%Y-%m-%d %H:%M:%S"), "high"),
    ("test_source", "Scraper framework released", "https://example.com/scraper-release", "data", time.strftime("%Y-%m-%d %H:%M:%S"), "medium"),
    ("test_source", "Payload builder CLI tool", "https://example.com/payload-cli", "live", time.strftime("%Y-%m-%d %H:%M:%S"), "high")
]

conn.executemany("INSERT INTO harvest (source, title, url, category, timestamp, severity) VALUES (?, ?, ?, ?, ?, ?);", entries)
conn.commit()
conn.close()
print("🧠 Injected 3 test entries into harvest.")

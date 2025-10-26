import pickle, os, sqlite3
db = os.path.expanduser("~/ScrapeForge/output/autonomous/autonomous.db")
model_path = os.path.expanduser("~/ScrapeForge/output/autonomous/ai_model.pkl")
conn = sqlite3.connect(db)
cursor = conn.execute("SELECT url, title FROM harvest WHERE category IN (\"live\", \"data\")")
rows = cursor.fetchall()
with open(model_path, "rb") as f:
    model = pickle.load(f)
for url, title in rows:
    vec = model["vectorizer"].transform([title])
    score = vec.sum()
    print(f"🔍 {title[:40]}... → Score: {score:.2f}")
conn.close()


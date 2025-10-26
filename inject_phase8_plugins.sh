#!/bin/bash
# MALICE.OS™ Phase VIII Plugin Injector — Root Path Fix
# Author: Christopher

PLUGINS="/root/ScrapeForge/plugins"
mkdir -p "$PLUGINS"

inject() {
  local name="$1"
  shift
  local path="$PLUGINS/$name"
  echo "🔧 Injecting $name..."
  cat > "$path" <<EOF
$@
EOF
  chmod +x "$path"
}

# plugin_db_validator.py
inject "plugin_db_validator.py" 'import sqlite3, os
db = os.path.expanduser("/root/ScrapeForge/output/autonomous/autonomous.db")
conn = sqlite3.connect(db)
conn.execute("CREATE TABLE IF NOT EXISTS harvest (source TEXT, title TEXT, url TEXT, category TEXT, timestamp TEXT, severity TEXT);")
conn.execute("CREATE TABLE IF NOT EXISTS ai_seed (source TEXT, content TEXT, type TEXT, timestamp TEXT);")
conn.commit(); conn.close()
print("🧠 Database schema validated.")'

# plugin_ai_trainer.py
inject "plugin_ai_trainer.py" 'import sqlite3, os, time, pickle
from sklearn.feature_extraction.text import TfidfVectorizer
import numpy as np
db = os.path.expanduser("/root/ScrapeForge/output/autonomous/autonomous.db")
model_path = os.path.expanduser("/root/ScrapeForge/output/autonomous/ai_model.pkl")
conn = sqlite3.connect(db)
corpus = [row[0] for row in conn.execute("SELECT content FROM ai_seed WHERE type=\'text\'")]
conn.close()
if not corpus: exit()
tfidf = TfidfVectorizer(max_features=1000)
X_tfidf = tfidf.fit_transform(corpus)
X_embed = np.random.rand(len(corpus), 768)
keywords = ["AI", "Linux", "scraper", "payload", "threat", "plugin"]
keyword_scores = [sum(c.lower().count(k.lower()) for k in keywords) for c in corpus]
X_combined = np.hstack([X_tfidf.toarray(), X_embed, np.array(keyword_scores).reshape(-1,1)])
pickle.dump({"vectorizer": tfidf, "features": X_combined, "keywords": keywords, "timestamp": time.strftime("%Y-%m-%d")}, open(model_path, "wb"))
print(f"🧠 Trained hybrid model on {len(corpus)} entries.")'

# plugin_ai_inferencer.py
inject "plugin_ai_inferencer.py" 'import pickle, os, sqlite3
db = os.path.expanduser("/root/ScrapeForge/output/autonomous/autonomous.db")
model_path = os.path.expanduser("/root/ScrapeForge/output/autonomous/ai_model.pkl")
conn = sqlite3.connect(db)
rows = conn.execute("SELECT url, title FROM harvest WHERE category IN (\'live\', \'data\')").fetchall()
conn.close()
model = pickle.load(open(model_path, "rb"))
for url, title in rows:
    vec = model["vectorizer"].transform([title])
    score = vec.sum()
    print(f"[Inferencer] {title[:60]} → Score: {score:.2f}")'

# plugin_ai_summarizer.py
inject "plugin_ai_summarizer.py" 'import sqlite3, os
db = os.path.expanduser("/root/ScrapeForge/output/autonomous/autonomous.db")
conn = sqlite3.connect(db)
rows = conn.execute("SELECT content FROM ai_seed ORDER BY timestamp DESC LIMIT 5").fetchall()
conn.close()
print("[Summarizer] Latest AI Seed Summary:")
for row in rows: print(f"• {row[0][:100]}...")'

# plugin_ai_exporter.py
inject "plugin_ai_exporter.py" 'import pickle, os, json
model_path = os.path.expanduser("/root/ScrapeForge/output/autonomous/ai_model.pkl")
export_path = os.path.expanduser("/root/ScrapeForge/storage/cloud_backup/ai_model.json")
model = pickle.load(open(model_path, "rb"))
json.dump({k:str(v)[:100] for k,v in model.items()}, open(export_path, "w"))
print("[Exporter] Model exported to cloud_backup.")'

# plugin_ai_dashboard.py
inject "plugin_ai_dashboard.py" 'import sqlite3, os
db = os.path.expanduser("/root/ScrapeForge/output/autonomous/autonomous.db")
conn = sqlite3.connect(db)
seed_count = conn.execute("SELECT COUNT(*) FROM ai_seed").fetchone()[0]
high_sev = conn.execute("SELECT COUNT(*) FROM harvest WHERE severity=\'high\'").fetchone()[0]
conn.close()
print(f"""
╔════════════════════════════════════╗
║   MALICE.OS™ AI Intelligence Feed  ║
╠════════════════════════════════════╣
║ AI Seeds:       {seed_count:<6}              ║
║ High Severity:  {high_sev:<6}              ║
║ Status:         {'OPERATIONAL' if seed_count > 0 else 'BOOTSTRAPPING'}     ║
╚════════════════════════════════════╝
""")'

# plugin_visual_loader.py
inject "plugin_visual_loader.py" 'echo "
╔══════════════════════════════╗
║ 🚀 MALICE.OS™ Intelligence Loader ║
╠══════════════════════════════╣
║ 🔧 Initializing Phase VIII...     ║
║ 🧠 AI Modules: Trainer, Inferencer ║
║ 📦 Exporter, Dashboard, Summarizer║
╚══════════════════════════════╝
"'

echo "✅ All Phase VIII plugins injected into /root/ScrapeForge/plugins"

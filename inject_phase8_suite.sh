#!/bin/bash
# MALICE.OS™ Phase VIII Injection Suite — Full Intelligence Expansion
# Author: Christopher

ROOT="$HOME/ScrapeForge"
PLUGINS="$ROOT/plugins"
LOGS="$ROOT/logs"
EXPORT="$ROOT/export"
mkdir -p "$PLUGINS" "$LOGS" "$EXPORT" "$ROOT/storage/cloud_backup"

inject() {
  local name="$1"
  shift
  local path="$PLUGINS/$name"
  echo "🔌 Injecting $name..."
  cat > "$path" <<EOF
$@
EOF
  chmod +x "$path"
}

# 🔧 Environment Bootstrapper
inject "plugin_env_bootstrapper.sh" '#!/bin/bash
pip3 install numpy scikit-learn matplotlib flask torch onnx transformers
echo "✅ Environment ready."
'

# 🔍 AI Inferencer
inject "plugin_ai_inferencer.py" 'import pickle, os, sqlite3
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
'

# 🧠 AI Summarizer
inject "plugin_ai_summarizer.py" 'import sqlite3, os
db = os.path.expanduser("~/ScrapeForge/output/autonomous/autonomous.db")
conn = sqlite3.connect(db)
cursor = conn.execute("SELECT content FROM ai_seed ORDER BY timestamp DESC LIMIT 5")
summary = "🧠 Summary:\n" + "\n".join([row[0][:100] + "..." for row in cursor.fetchall()])
print(summary)
conn.close()
'

# 📦 AI Exporter
inject "plugin_ai_exporter.py" 'import pickle, os, json
model_path = os.path.expanduser("~/ScrapeForge/output/autonomous/ai_model.pkl")
export_path = os.path.expanduser("~/ScrapeForge/storage/cloud_backup/ai_model.json")
with open(model_path, "rb") as f:
    model = pickle.load(f)
json.dump({k:str(v)[:100] for k,v in model.items()}, open(export_path, "w"))
print("📦 Model exported to cloud_backup.")
'

# 🎛️ AI Dashboard
inject "plugin_ai_dashboard.py" 'import sqlite3, os
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
'

# 🧪 File Checker
inject "plugin_file_checker.py" '#!/bin/bash
echo "🔍 Checking plugin integrity..."
for f in plugin_*.py; do
  if ! python3 "$f" >/dev/null 2>&1; then echo "❌ $f failed"; else echo "✅ $f OK"; fi
done
'

# 🎨 Visual Loader
inject "plugin_visual_loader.py" 'echo -e "🚀 MALICE.OS™ Loader\n🌐 Initializing...\n🔧 Plugins: 🧠 🔍 📦 🎛️ 🎨"'

echo "✅ Phase VIII plugins injected."


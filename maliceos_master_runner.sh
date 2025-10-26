#!/bin/bash
# MALICE.OS™ Master Runner — Full Suite Injector + Scraper
# Author: Christopher

set -e
echo -e "\n🔧 [$(date)] Starting MALICE.OS™ Master Runner..."

ROOT="$HOME/ScrapeForge"
PLUGINS="$ROOT/plugins"
LOGS="$ROOT/logs"
EXPORT="$ROOT/export"
DB="$ROOT/output/autonomous/autonomous.db"
ENABLED="$PLUGINS/.enabled_plugins"

mkdir -p "$PLUGINS" "$LOGS" "$EXPORT" "$ROOT/output/autonomous"

# 🔌 Inject all plugins if missing
declare -A PLUGIN_CODES

PLUGIN_CODES["plugin_csv_ingest.py"]='import csv, os
path = os.path.expanduser("~/ScrapeForge/export/harvest.csv")
with open(path, "w") as f:
    writer = csv.writer(f)
    writer.writerow(["source", "title", "url", "category", "timestamp"])
    writer.writerow(["csv_ingest", "Example", "http://example.com", "info", "2025-10-25"])
print("✅ CSV ingest complete.")'

PLUGIN_CODES["plugin_sql_ingest.py"]='import sqlite3, os
db_path = os.path.expanduser("~/ScrapeForge/output/autonomous/autonomous.db")
conn = sqlite3.connect(db_path)
conn.execute("INSERT INTO harvest VALUES (?, ?, ?, ?, ?)", (
    "sql_ingest", "SQL Title", "http://sql.com", "data", "2025-10-25"
))
conn.commit(); conn.close()
print("✅ SQL ingest complete.")'

PLUGIN_CODES["plugin_csv_to_sql.py"]='import csv, sqlite3, os
db_path = os.path.expanduser("~/ScrapeForge/output/autonomous/autonomous.db")
csv_path = os.path.expanduser("~/ScrapeForge/export/harvest.csv")
conn = sqlite3.connect(db_path)
with open(csv_path) as f:
    reader = csv.DictReader(f)
    for row in reader:
        conn.execute("INSERT INTO harvest VALUES (?, ?, ?, ?, ?)", (
            row["source"], row["title"], row["url"], row["category"], row["timestamp"]
        ))
conn.commit(); conn.close()
print("✅ CSV → SQL ingest complete.")'

PLUGIN_CODES["plugin_sql_export_json.py"]='import sqlite3, json, os
db_path = os.path.expanduser("~/ScrapeForge/output/autonomous/autonomous.db")
out_path = os.path.expanduser("~/ScrapeForge/export/harvest.json")
conn = sqlite3.connect(db_path)
cursor = conn.execute("SELECT * FROM harvest")
rows = [dict(zip([col[0] for col in cursor.description], row)) for row in cursor]
with open(out_path, "w") as f: json.dump(rows, f, indent=2)
conn.close(); print("📤 SQL → JSON export complete.")'

PLUGIN_CODES["plugin_sql_export_md.py"]='import sqlite3, os
db_path = os.path.expanduser("~/ScrapeForge/output/autonomous/autonomous.db")
out_path = os.path.expanduser("~/ScrapeForge/export/harvest.md")
conn = sqlite3.connect(db_path)
cursor = conn.execute("SELECT * FROM harvest")
with open(out_path, "w") as f:
    f.write("| Source | Title | URL | Category | Timestamp |\\n")
    f.write("|--------|-------|-----|----------|-----------|\\n")
    for row in cursor:
        f.write("| " + " | ".join(row) + " |\\n")
conn.close(); print("📄 SQL → Markdown export complete.")'

PLUGIN_CODES["plugin_sql_visualizer.py"]='import sqlite3, os
db_path = os.path.expanduser("~/ScrapeForge/output/autonomous/autonomous.db")
conn = sqlite3.connect(db_path)
cursor = conn.execute("SELECT category, COUNT(*) FROM harvest GROUP BY category")
print("📊 Category Counts:")
for row in cursor: print(f" - {row[0]}: {row[1]}")
conn.close()'

# Inject plugins
for plugin in "${!PLUGIN_CODES[@]}"; do
  if [ ! -f "$PLUGINS/$plugin" ]; then
    echo "🔌 [$(date)] Injecting $plugin..."
    echo "${PLUGIN_CODES[$plugin]}" > "$PLUGINS/$plugin"
  fi
done

# ✅ Register plugins
touch "$ENABLED"
for plugin in "${!PLUGIN_CODES[@]}"; do
  grep -qxF "$plugin" "$ENABLED" || echo "$plugin" >> "$ENABLED"
done

# 🧠 Create SQLite DB if missing
if [ ! -f "$DB" ]; then
  echo "🧠 [$(date)] Creating SQLite database..."
  sqlite3 "$DB" "CREATE TABLE IF NOT EXISTS harvest (source TEXT, title TEXT, url TEXT, category TEXT, timestamp TEXT);"
fi

# 🚀 Start 4-hour scraping loop (every 15 minutes)
echo "⏳ [$(date)] Starting 4-hour scraping loop..."
END=$((SECONDS + 14400))  # 4 hours = 14400 seconds

while [ $SECONDS -lt $END ]; do
  echo "🔁 [$(date)] Scrape cycle started..." | tee -a "$LOGS/scrape_loop.log"
  while read plugin; do
    PLUGIN_PATH="$PLUGINS/$plugin"
    echo "🔧 [$(date)] Running: $plugin" | tee -a "$LOGS/scrape_loop.log"
    if [ -f "$PLUGIN_PATH" ]; then
      if [[ "$plugin" == *.py ]]; then
        python3 "$PLUGIN_PATH" >> "$LOGS/scrape_loop.log" 2>&1 || echo "❌ Error in $plugin" >> "$LOGS/scrape_loop.log"
      elif [[ "$plugin" == *.sh ]]; then
        bash "$PLUGIN_PATH" >> "$LOGS/scrape_loop.log" 2>&1 || echo "❌ Error in $plugin" >> "$LOGS/scrape_loop.log"
      fi
    else
      echo "❌ Plugin not found: $plugin" >> "$LOGS/scrape_loop.log"
    fi
  done < "$ENABLED"
  echo "✅ [$(date)] Scrape cycle complete." | tee -a "$LOGS/scrape_loop.log"
  sleep 900  # 15 minutes
done

echo "🏁 [$(date)] 4-hour scraping loop finished."

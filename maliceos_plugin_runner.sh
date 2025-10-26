#!/bin/bash
# MALICE.OS™ Final Plugin Suite Builder & Runner
# Author: Christopher

set -e
echo -e "\n🔧 [$(date)] Building and executing MALICE.OS™ Plugin Suite..."

# 1. Define root paths
ROOT="$HOME/ScrapeForge"
PLUGINS="$ROOT/plugins"
LOGS="$ROOT/logs"
EXPORT="$ROOT/export"
DB="$ROOT/output/autonomous/autonomous.db"
ENABLED="$PLUGINS/.enabled_plugins"

# 2. Create full directory structure
echo "📁 [$(date)] Organizing root directory..."
mkdir -p "$ROOT"/{plugins,logs,export,output/autonomous,repo,storage/cloud_backup,agents,scripts,dashboard,modules}

# 3. Create SQLite database
echo "🧠 [$(date)] Creating SQLite database..."
sqlite3 "$DB" "CREATE TABLE IF NOT EXISTS harvest (source TEXT, title TEXT, url TEXT, category TEXT, timestamp TEXT);"

# 4. Inject sample plugin
echo "🔌 [$(date)] Injecting sample plugin..."
cat > "$PLUGINS/plugin_csv_ingest.py" <<EOF
import csv, os
path = os.path.expanduser("~/ScrapeForge/export/harvest.csv")
with open(path, "w") as f:
    writer = csv.writer(f)
    writer.writerow(["source", "title", "url", "category", "timestamp"])
    writer.writerow(["csv_ingest", "Example", "http://example.com", "info", "2025-10-25"])
EOF

# 5. Register plugin
echo "📋 [$(date)] Registering enabled plugin..."
echo "plugin_csv_ingest.py" > "$ENABLED"

# 6. Execute plugin
echo "🚀 [$(date)] Executing enabled plugins..."
> "$LOGS/plugin_runner.log"
while read plugin; do
  echo "🔧 [$(date)] Running: $plugin" | tee -a "$LOGS/plugin_runner.log"
  python3 "$PLUGINS/$plugin" >> "$LOGS/plugin_runner.log" 2>&1
done < "$ENABLED"

echo "✅ [$(date)] All plugins executed. Log saved to $LOGS/plugin_runner.log"

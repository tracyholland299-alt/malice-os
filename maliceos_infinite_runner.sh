#!/bin/bash
# MALICE.OS™ Phase IX — Infinite Intelligence Loop
# Author: Christopher

ROOT="$HOME/ScrapeForge"
PLUGINS="$ROOT/plugins"
LOGS="$ROOT/logs"
DB="$ROOT/output/autonomous/autonomous.db"
ENABLED="$PLUGINS/.enabled_plugins"
mkdir -p "$LOGS"

echo "🚀 MALICE.OS™ Infinite Intelligence Loop Starting..."
CYCLE=1

while true; do
  clear
  echo "🧠 Cycle #$CYCLE — $(date)"
  echo "──────────────────────────────────────────────"

  # Validate DB schema
  python3 "$PLUGINS/plugin_db_validator.py"

  # Run all enabled plugins
  while read plugin; do
    PLUGIN_PATH="$PLUGINS/$plugin"
    echo -n "🔧 Running: $plugin... "
    if [ -f "$PLUGIN_PATH" ]; then
      if [[ "$plugin" == *.py ]]; then
        python3 "$PLUGIN_PATH" >> "$LOGS/scrape_loop.log" 2>&1
      elif [[ "$plugin" == *.sh ]]; then
        bash "$PLUGIN_PATH" >> "$LOGS/scrape_loop.log" 2>&1
      fi
      echo "✅ Done"
    else
      echo "❌ Missing"
    fi
  done < "$ENABLED"

  # AI pipeline
  python3 "$PLUGINS/plugin_ai_seed_collector.py"
  python3 "$PLUGINS/plugin_ai_trainer.py"
  python3 "$PLUGINS/plugin_ai_inferencer.py"
  python3 "$PLUGINS/plugin_ai_summarizer.py"
  python3 "$PLUGINS/plugin_ai_exporter.py"
  python3 "$PLUGINS/plugin_ai_dashboard.py"

  # Visual loader
  bash "$PLUGINS/plugin_visual_loader.py"

  echo "✅ Cycle #$CYCLE Complete"
  echo "⏳ Sleeping 10 minutes before next cycle..."
  sleep 600
  CYCLE=$((CYCLE + 1))
done

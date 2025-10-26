tee /root/ScrapeForge/scripts/scrapeforge_control_panel.sh > /dev/null <<'EOF'
#!/bin/bash
clear
echo "███████╗███╗   ███╗ █████╗ ██╗     ██╗ ██████╗ ███████╗"
echo "██╔════╝████╗ ████║██╔══██╗██║     ██║██╔═══██╗██╔════╝"
echo "█████╗  ██╔████╔██║███████║██║     ██║██║   ██║███████╗"
echo "██╔══╝  ██║╚██╔╝██║██╔══██║██║     ██║██║   ██║╚════██║"
echo "███████╗██║ ╚═╝ ██║██║  ██║███████╗██║╚██████╔╝███████║"
echo "╚══════╝╚═╝     ╚═╝╚═╝  ╚═╝╚══════╝╚═╝ ╚═════╝ ╚══════╝"
echo "──────────────────────────────────────────────────────"
echo "🧠 MALICE.OS™ Modular Intelligence Suite"
echo "──────────────────────────────────────────────────────"

PLUGINS="/root/ScrapeForge/plugins"
LOG="/root/ScrapeForge/logs/control_panel_runtime.log"
TOTAL_PHASES=17
COMPLETED_PHASES=$(ls /root/ScrapeForge/scripts/phase_*_compiler.sh 2>/dev/null | wc -l)
TIME_LEFT=$(( (TOTAL_PHASES - COMPLETED_PHASES) * 120 / 60 ))

echo "📊 AI Progress: $COMPLETED_PHASES / $TOTAL_PHASES phases complete"
echo "⏱️ Estimated Time Remaining: $TIME_LEFT minutes"
echo "📦 Log File: $LOG"
echo "──────────────────────────────────────────────────────"

function show_main_menu() {
  echo "🔧 Select a module:"
  echo "  1) Payload Engine"
  echo "  2) Seed Intelligence"
  echo "  3) Model Operations"
  echo "  4) CLI Tools"
  echo "  5) Scraper System"
  echo "  6) Dashboards & Registry"
  echo "  7) System & Packaging"
  echo "  0) Exit"
}

function run_plugins_by_keyword() {
  KEY=$1
  echo "📂 Plugins matching '$KEY':"
  select PLUGIN in $(ls $PLUGINS | grep "$KEY") "Back"; do
    if [[ "$PLUGIN" == "Back" ]]; then break; fi
    if [[ -f "$PLUGINS/$PLUGIN" ]]; then
      echo "▶️ Executing $PLUGIN..."
      sudo python3 "$PLUGINS/$PLUGIN" >> "$LOG" 2>&1
      if [ $? -eq 0 ]; then echo "✅ $PLUGIN executed successfully"
      else echo "❌ $PLUGIN failed → check $LOG"; fi
    fi
  done
}

while true; do
  show_main_menu
  read -p "Select option: " CHOICE
  case $CHOICE in
    1) run_plugins_by_keyword "payload";;
    2) run_plugins_by_keyword "seed";;
    3) run_plugins_by_keyword "model";;
    4) run_plugins_by_keyword "cli";;
    5) run_plugins_by_keyword "scraper";;
    6) run_plugins_by_keyword "dashboard";;
    7) run_plugins_by_keyword "packager";;
    0) echo "👋 Exiting control panel. Logs saved to $LOG"; break;;
    *) echo "⚠️ Invalid selection. Try again.";;
  esac
done
EOF

chmod +x /root/ScrapeForge/scripts/scrapeforge_control_panel.sh	

#!/bin/bash
# MALICE.OS™ Debian Installer — Full Offline Build
# Author: Christopher

set -e
echo -e "\n🚀 Installing MALICE.OS™ on Debian..."

# 1. Create root folder
ROOT=~/ScrapeForge
mkdir -p "$ROOT"

# 2. Create folder structure
echo "📁 Creating folders..."
for DIR in ascii config dashboard export logs modules output/autonomous plugins repo scripts storage venv agents; do
  mkdir -p "$ROOT/$DIR"
done

# 3. Create SQLite database
echo "🧠 Creating SQLite database..."
sqlite3 "$ROOT/output/autonomous/autonomous.db" "CREATE TABLE IF NOT EXISTS harvest (source TEXT, title TEXT, url TEXT, category TEXT, timestamp TEXT);"

# 4. Inject plugin: plugin_csv_ingest.py
cat > "$ROOT/plugins/plugin_csv_ingest.py" <<EOF
import csv, requests
with open("~/ScrapeForge/export/harvest.csv", "w") as f:
    writer = csv.writer(f)
    writer.writerow(["source", "title", "url", "category", "timestamp"])
    writer.writerow(["csv_ingest", "Example", "http://example.com", "info", "2025-10-25"])
EOF

# 5. Inject plugin: plugin_cloud_sync.sh
cat > "$ROOT/plugins/plugin_cloud_sync.sh" <<EOF
#!/bin/bash
SOURCE=~/ScrapeForge/export
TARGET=~/ScrapeForge/storage/cloud_backup
LOG=~/ScrapeForge/logs/cloud_sync.log
echo "📡 Syncing exports to cloud..." | tee -a "\$LOG"
mkdir -p "\$TARGET"
rsync -avh --delete "\$SOURCE/" "\$TARGET/" >> "\$LOG" 2>&1
if [ \$? -eq 0 ]; then
  echo "✅ Sync complete: \$SOURCE → \$TARGET" | tee -a "\$LOG"
else
  echo "❌ Sync failed. Check log: \$LOG" | tee -a "\$LOG"
fi
EOF
chmod +x "$ROOT/plugins/plugin_cloud_sync.sh"

# 6. Inject dashboard launcher
cat > "$ROOT/scripts/dashboard.sh" <<EOF
#!/bin/bash
LOG=~/ScrapeForge/logs/dashboard.log
echo "🧠 Launching MALICE.OS™ Dashboard..." | tee -a "\$LOG"
echo "📊 Dashboard placeholder — replace with Streamlit or CLI UI" | tee -a "\$LOG"
EOF
chmod +x "$ROOT/scripts/dashboard.sh"

# 7. Inject README generator
cat > "$ROOT/readme_generator.py" <<EOF
import os
BASE = os.path.expanduser("~/ScrapeForge")
README = os.path.join(BASE, "README.md")
sections = {
    "scripts": "Shell automation scripts",
    "plugins": "Python and Bash ingestion modules",
    "dashboard": "Streamlit and CLI dashboards",
    "modules": "Core logic and runners",
    "output": "Scraped data and logs",
    "export": "JSON/CSV exports",
    "repo": "Cloned GitHub targets",
    "agents": "Auto-launched recon agents"
}
with open(README, "w") as f:
    f.write("# MALICE.OS™ Intelligence Suite\\n\\n")
    f.write("## 📁 Directory Structure\\n")
    for folder, desc in sections.items():
        f.write(f"- `{folder}/` — {desc}\\n")
    f.write("\\n## 🚀 Quick Start\\n")
    f.write("```bash\\ncd ~/ScrapeForge\\nbash scripts/dashboard.sh\\n```\\n")
    f.write("\\n## 🧩 Plugins\\n")
    for plugin in os.listdir(os.path.join(BASE, "plugins")):
        f.write(f"- `{plugin}`\\n")
    f.write("\\n## 🧠 Author\\nChristopher — Architect of MALICE.OS™, ScrapeForge, and autonomous CLI intelligence workflows.\\n")
print("✅ README.md generated.")
EOF

# 8. Inject plugin manager
cat > "$ROOT/plugin_manager.py" <<EOF
import curses, os
PLUGIN_DIR = os.path.expanduser("~/ScrapeForge/plugins")
ENABLED_FILE = os.path.join(PLUGIN_DIR, ".enabled_plugins")
def get_plugins(): return [f for f in os.listdir(PLUGIN_DIR) if f.endswith(".py") or f.endswith(".sh")]
def load_enabled(): return open(ENABLED_FILE).read().splitlines() if os.path.exists(ENABLED_FILE) else []
def save_enabled(enabled): open(ENABLED_FILE, "w").write("\\n".join(enabled))
def draw_menu(stdscr):
    curses.curs_set(0); plugins = get_plugins(); enabled = set(load_enabled()); selected = 0
    while True:
        stdscr.clear(); stdscr.addstr(0, 0, "🔌 MALICE.OS™ Plugin Manager", curses.A_BOLD)
        for i, plugin in enumerate(plugins):
            status = "[✔]" if plugin in enabled else "[ ]"
            mode = curses.A_REVERSE if i == selected else curses.A_NORMAL
            stdscr.addstr(i+2, 2, f"{status} {plugin}", mode)
        key = stdscr.getch()
        if key == curses.KEY_UP and selected > 0: selected -= 1
        elif key == curses.KEY_DOWN and selected < len(plugins) - 1: selected += 1
        elif key in [10, 13]:
            plugin = plugins[selected]
            if plugin in enabled: enabled.remove(plugin)
            else: enabled.add(plugin)
            save_enabled(list(enabled))
        elif key == 27: break
curses.wrapper(draw_menu)
EOF

# 9. Inject registry browser
cat > "$ROOT/plugin_registry_browser.py" <<EOF
import curses, os
PLUGIN_DIR = os.path.expanduser("~/ScrapeForge/plugins")
def draw_menu(stdscr):
    curses.curs_set(0)
    plugins = sorted([f for f in os.listdir(PLUGIN_DIR) if f.endswith(".py") or f.endswith(".sh")])
    selected = 0
    while True:
        stdscr.clear()
        stdscr.addstr(0, 0, "🧩 MALICE.OS™ Plugin Registry Browser", curses.A_BOLD)
        for i, plugin in enumerate(plugins):
            mode = curses.A_REVERSE if i == selected else curses.A_NORMAL
            stdscr.addstr(i+2, 2, plugin, mode)
        key = stdscr.getch()
        if key == curses.KEY_UP and selected > 0: selected -= 1
        elif key == curses.KEY_DOWN and selected < len(plugins) - 1: selected += 1
        elif key in [27, ord("q")]: break
curses.wrapper(draw_menu)
EOF

# 10. Generate README
echo "📘 Generating README.md..."
python3 "$ROOT/readme_generator.py"

# 11. Launch dashboard and plugin tools
echo "📊 Launching dashboard and plugin manager..."
bash "$ROOT/scripts/dashboard.sh"
python3 "$ROOT/plugin_manager.py"
python3 "$ROOT/plugin_registry_browser.py"

echo "✅ MALICE.OS™ fully installed and launched on Debian."

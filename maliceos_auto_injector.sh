#!/bin/bash
# MALICE.OS™ Auto Injector & Suite Expander
# Author: Christopher

set -e
echo -e "\n🔧 [$(date)] Injecting advanced modules into MALICE.OS™..."

ROOT="$HOME/ScrapeForge"
PLUGINS="$ROOT/plugins"
LOGS="$ROOT/logs"
EXPORT="$ROOT/export"
ENABLED="$PLUGINS/.enabled_plugins"

mkdir -p "$PLUGINS" "$LOGS" "$EXPORT"

# 🔐 Encrypt Export Plugin
cat > "$PLUGINS/plugin_encrypt_export.py" <<EOF
import os
from cryptography.fernet import Fernet
key = Fernet.generate_key()
cipher = Fernet(key)
with open(os.path.expanduser("~/ScrapeForge/export/harvest.csv"), "rb") as f:
    data = f.read()
encrypted = cipher.encrypt(data)
with open(os.path.expanduser("~/ScrapeForge/export/harvest_encrypted.bin"), "wb") as f:
    f.write(encrypted)
print("🔐 Export encrypted.")
EOF

# 📜 Changelog Generator
cat > "$PLUGINS/plugin_changelog_generator.py" <<EOF
import os
log = os.path.expanduser("~/ScrapeForge/logs/plugin_runner.log")
out = os.path.expanduser("~/ScrapeForge/export/changelog.txt")
with open(log) as f: lines = f.readlines()
with open(out, "w") as f:
    for line in lines:
        if "Running:" in line or "Tagged:" in line or "Benchmark:" in line:
            f.write(line)
print("📜 Changelog generated.")
EOF

# 📊 Graph Visualizer
cat > "$PLUGINS/plugin_graph_visualizer.py" <<EOF
import networkx as nx
from pyvis.network import Network
import os
G = nx.DiGraph()
plugins = ["csv_ingest", "sql_ingest", "auto_tagger", "benchmark", "registry", "cloner", "agent", "exporter", "sync", "loader"]
for i in range(len(plugins)-1): G.add_edge(plugins[i], plugins[i+1])
net = Network()
net.from_nx(G)
net.show(os.path.expanduser("~/ScrapeForge/export/plugin_graph.html"))
print("📊 Plugin graph visualized.")
EOF

# 🚨 Error Reporter
cat > "$PLUGINS/plugin_error_reporter.py" <<EOF
import os
log = os.path.expanduser("~/ScrapeForge/logs/plugin_runner.log")
errors = []
with open(log) as f:
    for line in f:
        if "❌" in line or "Error" in line: errors.append(line)
with open(os.path.expanduser("~/ScrapeForge/export/error_report.txt"), "w") as f:
    f.writelines(errors)
print("🚨 Error report generated.")
EOF

# 🧩 Plugin Toggle UI
cat > "$PLUGINS/plugin_toggle_ui.py" <<EOF
import curses, os
PLUGIN_DIR = os.path.expanduser("~/ScrapeForge/plugins")
ENABLED_FILE = os.path.join(PLUGIN_DIR, ".enabled_plugins")
def get_plugins(): return [f for f in os.listdir(PLUGIN_DIR) if f.endswith(".py") or f.endswith(".sh")]
def load_enabled(): return open(ENABLED_FILE).read().splitlines() if os.path.exists(ENABLED_FILE) else []
def save_enabled(enabled): open(ENABLED_FILE, "w").write("\\n".join(enabled))
def draw_menu(stdscr):
    curses.curs_set(0); plugins = get_plugins(); enabled = set(load_enabled()); selected = 0
    while True:
        stdscr.clear(); stdscr.addstr(0, 0, "🔌 MALICE.OS™ Plugin Toggle UI", curses.A_BOLD)
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

# 🛠️ Auto-fix Shell Scripts
cat > "$PLUGINS/plugin_shell_autofix.py" <<EOF
import os
ROOT = os.path.expanduser("~/ScrapeForge")
LOG = os.path.join(ROOT, "logs/shell_autofix.log")
def fix_script(path):
    with open(path) as f: lines = f.readlines()
    fixed = []; for line in lines:
        if line.count('"') % 2 != 0: line = line.rstrip() + '"\\n'
        fixed.append(line)
    with open(path, "w") as f: f.writelines(fixed)
    with open(LOG, "a") as log: log.write(f"✅ Fixed: {path}\\n")
for root, _, files in os.walk(ROOT):
    for file in files:
        if file.endswith(".sh"):
            try: fix_script(os.path.join(root, file))
            except Exception as e:
                with open(LOG, "a") as log: log.write(f"❌ Error fixing {file}: {str(e)}\\n")
print("🛠️ Shell script auto-fix complete.")
EOF

# ✅ Update registry
echo "📋 [$(date)] Updating plugin registry..."
cat >> "$ENABLED" <<EOF
plugin_encrypt_export.py
plugin_changelog_generator.py
plugin_graph_visualizer.py
plugin_error_reporter.py
plugin_toggle_ui.py
plugin_shell_autofix.py
EOF

# 🚀 Execute all plugins
echo "🚀 [$(date)] Executing all plugins..."
> "$LOGS/plugin_runner.log"
while read plugin; do
  echo "🔧 [$(date)] Running: $plugin" | tee -a "$LOGS/plugin_runner.log"
  if [[ "$plugin" == *.py ]]; then
    python3 "$PLUGINS/$plugin" >> "$LOGS/plugin_runner.log" 2>&1
  elif [[ "$plugin" == *.sh ]]; then
    bash "$PLUGINS/$plugin" >> "$LOGS/plugin_runner.log" 2>&1
  fi
done < "$ENABLED"

echo "✅ [$(date)] All plugins executed. Log saved to $LOGS/plugin_runner.log"

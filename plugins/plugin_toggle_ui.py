import curses, os
PLUGIN_DIR = os.path.expanduser("~/ScrapeForge/plugins")
ENABLED_FILE = os.path.join(PLUGIN_DIR, ".enabled_plugins")
def get_plugins(): return [f for f in os.listdir(PLUGIN_DIR) if f.endswith(".py") or f.endswith(".sh")]
def load_enabled(): return open(ENABLED_FILE).read().splitlines() if os.path.exists(ENABLED_FILE) else []
def save_enabled(enabled): open(ENABLED_FILE, "w").write("\n".join(enabled))
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

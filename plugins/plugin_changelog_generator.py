import os
log = os.path.expanduser("~/ScrapeForge/logs/plugin_runner.log")
out = os.path.expanduser("~/ScrapeForge/export/changelog.txt")
with open(log) as f: lines = f.readlines()
with open(out, "w") as f:
    for line in lines:
        if "Running:" in line or "Tagged:" in line or "Benchmark:" in line:
            f.write(line)
print("📜 Changelog generated.")

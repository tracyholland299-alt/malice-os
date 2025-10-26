import os
log = os.path.expanduser("~/ScrapeForge/logs/plugin_runner.log")
errors = []
with open(log) as f:
    for line in f:
        if "❌" in line or "Error" in line: errors.append(line)
with open(os.path.expanduser("~/ScrapeForge/export/error_report.txt"), "w") as f:
    f.writelines(errors)
print("🚨 Error report generated.")

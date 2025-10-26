import os
ROOT = os.path.expanduser("~/ScrapeForge")
LOG = os.path.join(ROOT, "logs/shell_autofix.log")
def fix_script(path):
    with open(path) as f: lines = f.readlines()
    fixed = []; for line in lines:
        if line.count('"') % 2 != 0: line = line.rstrip() + '"\n'
        fixed.append(line)
    with open(path, "w") as f: f.writelines(fixed)
    with open(LOG, "a") as log: log.write(f"✅ Fixed: {path}\n")
for root, _, files in os.walk(ROOT):
    for file in files:
        if file.endswith(".sh"):
            try: fix_script(os.path.join(root, file))
            except Exception as e:
                with open(LOG, "a") as log: log.write(f"❌ Error fixing {file}: {str(e)}\n")
print("🛠️ Shell script auto-fix complete.")

import requests, os, json
out_json = os.path.expanduser("~/ScrapeForge/export/repos.json")
repos = ["https://github.com/tensorflow/tensorflow", "https://github.com/numpy/numpy"]
data = []
for repo in repos:
    api = repo.replace("https://github.com/", "https://api.github.com/repos/")
    try:
        r = requests.get(api, timeout=5).json()
        data.append({
            "name": r.get("name"), "desc": r.get("description"),
            "stars": r.get("stargazers_count"), "url": repo
        })
    except: pass
with open(out_json, "w") as f: json.dump(data, f, indent=2)
print(f"📦 Rebuilt metadata for {len(data)} repos.")

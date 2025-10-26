import requests, re, os
out = os.path.expanduser("~/ScrapeForge/export/targets.txt")
seed_urls = ["https://news.ycombinator.com", "https://github.com/trending", "https://www.reddit.com/r/programming"]
found = set()
for url in seed_urls:
    try:
        html = requests.get(url, timeout=5).text
        links = re.findall(r'href=["\'](https?://[^"\']+)["\']', html)
        for link in links:
            if "http" in link and len(link) < 100:
                found.add(link)
    except: pass
with open(out, "w") as f:
    for link in sorted(found): f.write(link + "\n")
print(f"🔍 Scanned {len(seed_urls)} seeds, found {len(found)} targets.")

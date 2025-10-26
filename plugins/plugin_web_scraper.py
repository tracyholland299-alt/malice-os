import requests, csv, os, time
targets = os.path.expanduser("~/ScrapeForge/export/targets.txt")
out_csv = os.path.expanduser("~/ScrapeForge/export/harvest.csv")
rows = []
with open(targets) as f:
    for url in f:
        url = url.strip()
        try:
            html = requests.get(url, timeout=5).text
            title = html.split("<title>")[1].split("</title>")[0][:100]
            rows.append(["web_scraper", title, url, "live", time.strftime("%Y-%m-%d")])
        except: pass
with open(out_csv, "a") as f:
    writer = csv.writer(f)
    for row in rows: writer.writerow(row)
print(f"🌐 Scraped {len(rows)} live pages.")

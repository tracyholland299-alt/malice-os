import csv, os
path = os.path.expanduser("~/ScrapeForge/export/harvest.csv")
with open(path, "w") as f:
    writer = csv.writer(f)
    writer.writerow(["source", "title", "url", "category", "timestamp"])
    writer.writerow(["csv_ingest", "Example", "http://example.com", "info", "2025-10-25"])

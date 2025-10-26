import pickle, os, json
model_path = os.path.expanduser("~/ScrapeForge/output/autonomous/ai_model.pkl")
export_path = os.path.expanduser("~/ScrapeForge/storage/cloud_backup/ai_model.json")
with open(model_path, "rb") as f:
    model = pickle.load(f)
json.dump({k:str(v)[:100] for k,v in model.items()}, open(export_path, "w"))
print("📦 Model exported to cloud_backup.")


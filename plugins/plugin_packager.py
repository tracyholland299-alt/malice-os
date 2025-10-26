import shutil, os
shutil.make_archive(os.path.expanduser("~/ScrapeForge/export/maliceos_bundle"), "zip", os.path.expanduser("~/ScrapeForge"))
print("📦 Suite packaged for resale.")

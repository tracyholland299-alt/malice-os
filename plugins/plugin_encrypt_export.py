import os
from cryptography.fernet import Fernet
key = Fernet.generate_key()
cipher = Fernet(key)
with open(os.path.expanduser("~/ScrapeForge/export/harvest.csv"), "rb") as f:
    data = f.read()
encrypted = cipher.encrypt(data)
with open(os.path.expanduser("~/ScrapeForge/export/harvest_encrypted.bin"), "wb") as f:
    f.write(encrypted)
print("🔐 Export encrypted.")

#!/bin/bash
# MALICE.OS™ Debian Environment Setup
# Author: Christopher

set -e
echo -e "\n🚀 Setting up MALICE.OS™ Python environment on Debian..."

# 1. Update system and install dependencies
echo "📦 Installing system packages..."
sudo apt update && sudo apt install -y \
  python3 python3-pip python3-venv \
  sqlite3 rsync curl build-essential \
  libffi-dev libssl-dev libxml2-dev libxslt1-dev zlib1g-dev

# 2. Create project folder if missing
PROJECT_DIR=~/ScrapeForge
mkdir -p "$PROJECT_DIR"

# 3. Create virtual environment
echo "🧪 Creating Python virtual environment..."
python3 -m venv "$PROJECT_DIR/venv"

# 4. Activate environment and upgrade pip
source "$PROJECT_DIR/venv/bin/activate"
pip install --upgrade pip

# 5. Install Python dependencies
echo "📦 Installing Python packages..."
pip install streamlit langchain fpdf networkx pyvis

# 6. Create SQLite database
echo "🧠 Creating SQLite database..."
mkdir -p "$PROJECT_DIR/output/autonomous"
sqlite3 "$PROJECT_DIR/output/autonomous/autonomous.db" \
  "CREATE TABLE IF NOT EXISTS harvest (source TEXT, title TEXT, url TEXT, category TEXT, timestamp TEXT);"

# 7. Confirm environment setup
echo "✅ Virtual environment setup complete."
echo "🧠 To activate MALICE.OS™ environment, run:"
echo "source ~/ScrapeForge/venv/bin/activate"

# 8. Optional: Launch compiler if present
if [ -f "$PROJECT_DIR/maliceos_final_compiler.sh" ]; then
  echo "🚀 Launching MALICE.OS™ compiler..."
  bash "$PROJECT_DIR/maliceos_final_compiler.sh"
else
  echo "⚠️ Compiler script not found. You can run it manually once injected."
fi

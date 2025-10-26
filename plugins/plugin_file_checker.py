#!/bin/bash
echo "🔍 Checking plugin integrity..."
for f in plugin_*.py; do
  if ! python3 "$f" >/dev/null 2>&1; then echo "❌ $f failed"; else echo "✅ $f OK"; fi
done


import sqlite3, os, time
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity
import numpy as np
import pickle

db = os.path.expanduser("~/ScrapeForge/output/autonomous/autonomous.db")
model_path = os.path.expanduser("~/ScrapeForge/output/autonomous/ai_model.pkl")

conn = sqlite3.connect(db)
cursor = conn.execute("SELECT content FROM ai_seed WHERE type='text'")
corpus = [row[0] for row in cursor.fetchall()]
conn.close()

if not corpus:
    print("⚠️ No AI seed data found.")
    exit()

# TF-IDF vectorization
tfidf = TfidfVectorizer(max_features=1000)
X_tfidf = tfidf.fit_transform(corpus)

# Embedding simulation (placeholder for real embeddings)
X_embed = np.random.rand(len(corpus), 768)

# Keyword classifier (simple match count)
keywords = ["AI", "Linux", "scraper", "payload", "threat", "plugin"]
keyword_scores = [sum(content.lower().count(k.lower()) for k in keywords) for content in corpus]
keyword_scores = np.array(keyword_scores).reshape(-1, 1)

# Combine all features
X_combined = np.hstack([X_tfidf.toarray(), X_embed, keyword_scores])

# Save model
with open(model_path, "wb") as f:
    pickle.dump({
        "vectorizer": tfidf,
        "features": X_combined,
        "keywords": keywords,
        "timestamp": time.strftime("%Y-%m-%d")
    }, f)

print(f"🧠 Hybrid model trained on {len(corpus)} entries. Saved to ai_model.pkl.")	

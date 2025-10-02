# backend/settings.py
import os, dj_database_url
from pathlib import Path
BASE_DIR = Path(__file__).resolve().parent.parent

DEBUG = os.environ.get("DEBUG", "False").lower() == "true"

db_url = os.environ.get("DATABASE_URL")

# On Render, require DATABASE_URL; never try localhost.
if os.environ.get("RENDER", "") == "1":
    if not db_url:
        raise RuntimeError("DATABASE_URL must be set on Render.")
    DATABASES = {"default": dj_database_url.parse(db_url, conn_max_age=600)}
else:
    # Local/dev: use DATABASE_URL if present, else SQLite
    DATABASES = (
        {"default": dj_database_url.parse(db_url, conn_max_age=600)}
        if db_url
        else {
            "default": {
                "ENGINE": "django.db.backends.sqlite3",
                "NAME": BASE_DIR / "db.sqlite3",
            }
        }
    )

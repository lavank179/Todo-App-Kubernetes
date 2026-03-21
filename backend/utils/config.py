import os
from pathlib import Path

env_path = Path(__file__).resolve().parent.parent / ".env"
if env_path.exists():
    with open(env_path) as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith("#"):
                continue
            key, value = line.split("=", 1)
            # Remove possible quotes from the .env value
            os.environ[key] = value.strip("'").strip('"')

class Settings:
    APP_DB_USER = os.getenv("APP_DB_USER", "postgres")
    APP_DB_PASSWORD = os.getenv("APP_DB_PASSWORD")
    DB_HOST = os.getenv("DB_HOST", "localhost")
    APP_DB = os.getenv("APP_DB", "tasks_db")
    VIDEO_PATH = os.getenv("VIDEO_PATH", "video.mp4")

settings = Settings()

import os
from pathlib import Path

# 1. READ THE FILE FIRST
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

# 2. NOW DEFINE THE CLASS
class Settings:
    # Now os.getenv will see the variables we just added to os.environ
    APP_DB_USER = os.getenv("APP_DB_USER", "postgres")
    APP_DB_PASSWORD = os.getenv("APP_DB_PASSWORD")
    DB_HOST = os.getenv("DB_HOST", "localhost")
    APP_DB = os.getenv("APP_DB", "tasks_db")

# 3. INITIALIZE
settings = Settings()

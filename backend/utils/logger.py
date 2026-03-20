import os
import logging
import json
from pathlib import Path
from datetime import datetime

# 1. Get the Root Directory (similar to path.join(__dirname, '..'))
# Assuming this file is in 'backend/utils/logger.py'
BASE_DIR = Path(__file__).resolve().parent.parent 
LOGS_DIR = BASE_DIR / "tlogs"
LOG_FILE_PATH = LOGS_DIR / "app.log"

# 2. Ensure logs directory exists (similar to fs.mkdirSync)
if not LOGS_DIR.exists():
    LOGS_DIR.mkdir(parents=True, exist_ok=True)

# 3. Custom JSON Formatter
class JSONFormatter(logging.Formatter):
    def format(self, record):
        log_record = {
            "timestamp": datetime.utcnow().isoformat(),
            "level": record.levelname,
            "message": record.getMessage(),
        }
        return json.dumps(log_record)

# 4. Setup Logger
def setup_logger():
    logger = logging.getLogger("app")
    logger.setLevel(logging.INFO)

    # File Handler using the path we created
    file_handler = logging.FileHandler(LOG_FILE_PATH)
    file_handler.setFormatter(JSONFormatter())
    
    # Console Handler
    console_handler = logging.StreamHandler()
    console_handler.setFormatter(JSONFormatter())

    logger.handlers = [file_handler, console_handler]
    
    # # Redirect Uvicorn logs to the same file
    # for name in ["uvicorn", "uvicorn.error", "uvicorn.access"]:
    #     u_logger = logging.getLogger(name)
    #     u_logger.handlers = [file_handler, console_handler]
    #     u_logger.propagate = False

    # # Silence SQLAlchemy: Set to WARNING to only see errors/important logs
    # sql_logger = logging.getLogger("sqlalchemy.engine")
    # sql_logger.setLevel(logging.WARNING) 
    return logger

logger = setup_logger()

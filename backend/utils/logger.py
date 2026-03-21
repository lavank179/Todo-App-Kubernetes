import json, traceback, os, logging, logging.config, asyncio
from datetime import datetime
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent
LOGS_DIR = BASE_DIR / "tlogs"
LOG_FILE_PATH = LOGS_DIR / "app.log"

LOGS_DIR.mkdir(parents=True, exist_ok=True)


class JSONFormatter(logging.Formatter):
    def format(self, record):
        message = record.getMessage()
        # If message is already JSON, don't wrap it again
        try:
            parsed = json.loads(message)
            if isinstance(parsed, dict):
                return message
        except Exception:
            pass

        logger_name = record.name
        if logger_name.startswith("uvicorn"):
            logger_name = "server"
        elif logger_name.startswith("sqlalchemy"):
            logger_name = "db"
        log_record = {
            "timestamp": datetime.utcnow().isoformat(timespec="milliseconds"),
            "level": record.levelname.lower(),
            "pid": os.getpid(),
            "logger": logger_name,
            "message": message,
        }
        if record.exc_info:
            log_record["exception"] = "".join(
                traceback.format_exception(*record.exc_info)
            )
        return json.dumps(log_record)


LOGGING_CONFIG = {
    "version": 1,
    "disable_existing_loggers": False,

    "formatters": {
        "json": {"()": JSONFormatter},
    },

    "handlers": {
        "file": {
            "class": "logging.FileHandler",
            "filename": str(LOG_FILE_PATH),
            "formatter": "json",
        },
    },

    "root": {
        "handlers": ["file"],
        "level": "INFO",
    },

    "loggers": {
        "uvicorn": {"level": "INFO"},
        "uvicorn.error": {"level": "INFO"},
        "uvicorn.access": {"level": "INFO"},

        "sqlalchemy.engine": {"level": "WARNING"},
        "sqlalchemy.pool": {"level": "WARNING"},
    },
}

def setup_logging():
    logging.config.dictConfig(LOGGING_CONFIG)

def get_logger(name="app"):
    return logging.getLogger(name)

logger = get_logger("app") # Actual export

def handle_exception(exc_type, exc_value, exc_traceback):
    if issubclass(exc_type, KeyboardInterrupt):
        return

    logger.error(
        "Unhandled exception",
        exc_info=(exc_type, exc_value, exc_traceback)
    )

def handle_async_exception(loop, context):
    msg = context.get("exception", context["message"])
    logger.error(f"Async exception: {msg}", exc_info=True)

loop = asyncio.get_event_loop()
loop.set_exception_handler(handle_async_exception)
import uvicorn, sys
from utils.logger import setup_logging, handle_exception

if __name__ == "__main__":
    setup_logging()
    sys.excepthook = handle_exception

    uvicorn.run(
        "app:app",
        host="0.0.0.0",
        port=8881,
        log_config=None,     #(disable uvicorn logging override)
        access_log=False     # optional (since we're controlling logging anyway)
    )
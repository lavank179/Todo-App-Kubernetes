from fastapi import Request, HTTPException
from fastapi.responses import StreamingResponse
import os


VIDEO_PATH = "video.mp4"
CHUNK_SIZE = 1 * 10**6  # 1MB

async def stream_video(request: Request):
    range_header = request.headers.get("range")
    file_size = os.path.getsize(VIDEO_PATH)

    if not range_header:
        raise HTTPException(status_code=416, detail="Range header required")

    # Parse Range header (e.g., "bytes=1000-")
    try:
        start = int(range_header.split("=")[1].split("-")[0])
    except Exception:
        raise HTTPException(status_code=400, detail="Invalid Range header")

    end = min(start + CHUNK_SIZE, file_size - 1)
    content_length = end - start + 1

    def iterfile():
        with open(VIDEO_PATH, "rb") as f:
            f.seek(start)
            remaining = content_length
            while remaining > 0:
                chunk = f.read(min(8192, remaining))
                if not chunk:
                    break
                remaining -= len(chunk)
                yield chunk

    headers = {
        "Content-Range": f"bytes {start}-{end}/{file_size}",
        "Accept-Ranges": "bytes",
        "Content-Length": str(content_length),
        "Content-Type": "video/mp4",
    }

    return StreamingResponse(iterfile(), status_code=206, headers=headers)
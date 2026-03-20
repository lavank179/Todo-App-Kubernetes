from fastapi import FastAPI, APIRouter, Request
from fastapi.responses import HTMLResponse
from routers import task_router
from fastapi.middleware.cors import CORSMiddleware
from utils.video_streamer import stream_video
from utils.stress import stressCPUBlocking
from utils.logger import logger

api_router = APIRouter(prefix="/api")

@api_router.get("/health")
def health():
    return ["healthy!"]

api_router.include_router(task_router.router)


app = FastAPI()
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"], # For testing; change to your UI URL later
    allow_credentials=True,
    allow_methods=["*"], # Important: allows OPTIONS, POST, PUT, etc.
    allow_headers=["*"],
)
app.include_router(api_router)


@app.get("/")
def message():
    return HTMLResponse('<h1>Welcome to Todo App</h1>')

@app.get("/videoplayer")
async def video(request: Request):
    return await stream_video(request)

@app.get("/stress")
async def stress():
    stressed = await stressCPUBlocking(500000000)
    return f'Stress Completed! counted: {stressed}'

logger.info("Todo-App api started successfully!")
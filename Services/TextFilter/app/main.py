import os

from fastapi import FastAPI

from app.api.text_filter import router as text_filter_router

app = FastAPI(
    debug=os.getenv("API_DEBUG", "false").lower() == "true"
)

app.include_router(text_filter_router, prefix="/text-filter")
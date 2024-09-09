import os

from fastapi import FastAPI

from app.api.text_filter import router as text_filter_router
from app.api.feedback import router as feedback_router

app = FastAPI(debug=os.getenv("API_DEBUG", "false").lower() == "true")

app.include_router(text_filter_router, prefix="/text-filter")
app.include_router(feedback_router, prefix="/feedback")

from fastapi import FastAPI

from app.config import config
from app.api.text_filter import router as text_filter_router
from app.api.feedback import router as feedback_router

app = FastAPI(
    debug=config.API_DEBUG
)

app.include_router(text_filter_router, prefix="/text-filter")
app.include_router(feedback_router, prefix="/feedback")

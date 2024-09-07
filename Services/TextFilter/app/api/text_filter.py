from fastapi import APIRouter

from app.services.text_filter_service import TextFilterService
from app.models import TextFilterRequest, TextFilterResponse

router = APIRouter()
text_filter_service = TextFilterService()

@router.post("/v1/filter-text", response_model=TextFilterResponse)
async def filter_text(request: TextFilterRequest):
    return text_filter_service.filter_text(request.text)
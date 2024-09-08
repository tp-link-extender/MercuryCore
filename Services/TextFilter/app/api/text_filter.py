from fastapi import APIRouter

from app.services.text_filter_service import TextFilterService
from app.models import TextFilter

router = APIRouter()
text_filter_service = TextFilterService()

@router.post("/v1/filter-text", response_model=TextFilter.v1.FilterTextResponse)
async def filter_text(request: TextFilter.v1.FilterTextRequest):
    return text_filter_service.filter_text(request.text)
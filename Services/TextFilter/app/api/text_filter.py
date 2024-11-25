from fastapi import APIRouter

from app.services.text_filter_service import TextFilterService
from app.models import text_filter

router = APIRouter()
text_filter_service = TextFilterService()


@router.post("/filter-text", response_model=text_filter.FilterTextResponse)
async def filter_text(request: text_filter.FilterTextRequest):
	return text_filter_service.filter_text(request)

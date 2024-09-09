from fastapi import APIRouter

from app.services.text_filter_service import TextFilterService
from app.models import text_filter

router = APIRouter()
text_filter_service = TextFilterService()


@router.post("/v1/filter-text", response_model=text_filter.v1.FilterTextResponse)
async def filter_text(request: text_filter.v1.FilterTextRequest):
	return text_filter_service.filter_text(request.text)

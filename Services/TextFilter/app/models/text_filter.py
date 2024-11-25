from pydantic import BaseModel
from typing import List


class FilterTextRequest(BaseModel):
	text: str


class FilterTextResponse(BaseModel):
	filtered: bool
	filtered_text: str
	reasons: List[str]

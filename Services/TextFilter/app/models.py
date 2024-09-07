from pydantic import BaseModel
from typing import List

class TextFilterRequest(BaseModel):
    text: str

class TextFilterResponse(BaseModel):
    filtered: bool
    filtered_text: str
    reasons: List[str]
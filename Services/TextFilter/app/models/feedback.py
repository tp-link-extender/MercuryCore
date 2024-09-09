from pydantic import BaseModel
from typing import Optional, List

class v1:
	class AISubmission(BaseModel):
		id: str
		text: str
		detected_score: float
		detected_is_offensive: bool
		state: str

	class HumanReview(BaseModel):
		id: str
		new_score: float
		new_is_offensive: bool
		offensive_parts: Optional[List[str]] = None

from fastapi import APIRouter, HTTPException

from app.models import feedback
from app.services.feedback_service import FeedbackService
from app.enums.state import state


router = APIRouter()
feedback_service = FeedbackService()


@router.get("/review-queue")
async def get_review_queue(state: state):
	items = feedback_service.get_queue(state=state)
	return [item.model_dump() for item in items]


@router.post("/submit-review")
async def submit_feedback(review: feedback.HumanReview):
	success = feedback_service.update_review_status(review_submission=review)
	return (
		{"detail": "Review submitted"}
		if success
		else HTTPException(status_code=400, detail="Unable to submit review")
	)

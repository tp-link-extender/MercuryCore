from fastapi import APIRouter, HTTPException

# TODO: Implement feedback service to train the model based on moderator feedback

router = APIRouter()

@router.get("/v1/review-queue")
async def feedback_queue():
    raise HTTPException(status_code=501)

@router.get("/v1/submit-feedback/{id}")
async def feedback_queue(id: str):
    raise HTTPException(status_code=501)
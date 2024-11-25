import uuid

from typing import List, Optional, Callable

from app.redis import RedisClient
from app.models import feedback
from app.enums.state import state


class FeedbackService:
	def __init__(self):
		self.redis = RedisClient().singleton()
		self.queue_key = "feedback_queue"

	def _find_feedback(
		self, condition: Callable[[feedback.AISubmission], bool]
	) -> Optional[int]:
		for idx, item in enumerate(self.redis.lrange(self.queue_key, 0, -1)):
			model = feedback.AISubmission.model_validate_json(item)
			if condition(model):
				return idx
		return None

	def _is_duplicate(self, text: str) -> bool:
		return self._find_feedback(lambda model: model.text == text) is not None

	def add_to_queue(
		self, text: str, detected_score: float, detected_is_offensive: bool
	) -> Optional[str]:
		if self._is_duplicate(text):
			return None

		item = feedback.AISubmission(
			id=str(uuid.uuid4()),
			text=text,
			detected_score=detected_score,
			detected_is_offensive=detected_is_offensive,
			state=state.PENDING,
		)
		self.redis.rpush(self.queue_key, item.model_dump_json())
		return item.id

	def get_queue(self, state: str = state.PENDING) -> List[feedback.AISubmission]:
		items = self.redis.lrange(self.queue_key, 0, -1)
		return [
			feedback.AISubmission.model_validate_json(item)
			for item in items
			if feedback.AISubmission.model_validate_json(item).state == state
		]

	def update_review_status(self, review_submission: feedback.HumanReview) -> bool:
		index = self._find_feedback(lambda model: model.id == review_submission.id)
		if index is None:
			return False

		ai_submission_item = feedback.AISubmission.model_validate_json(
			self.redis.lrange(self.queue_key, index, index)[0]
		)

		human_review_item = ai_submission_item.model_copy(
			update={
				"detected_score": review_submission.new_score,
				"detected_is_offensive": review_submission.new_is_offensive,
				"offensive_parts": review_submission.offensive_parts,
				"state": state.REVIEWED,
			}
		)

		self.redis.lset(self.queue_key, index, human_review_item.model_dump_json())

		self.train_model(human_review_item, ai_submission_item)
		return True

	def train_model(
		self,
		reviewed_item: feedback.HumanReview,
		previous_item: feedback.AISubmission,
	):
		# TODO
		pass

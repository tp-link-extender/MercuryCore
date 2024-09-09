import os

from typing import Dict, List
from transformers import pipeline, AutoTokenizer

from app.models import text_filter
from app.services.feedback_service import FeedbackService


# model: https://huggingface.co/badmatr11x/distilroberta-base-offensive-hateful-speech-text-multiclassification
# model labels: https://huggingface.co/badmatr11x/distilroberta-base-offensive-hateful-speech-text-multiclassification/blob/main/config.json
class TextFilterService:
	def __init__(self):
		self.classifier = pipeline(
			"text-classification",
			model="badmatr11x/distilroberta-base-offensive-hateful-speech-text-multiclassification",
		)
		self.tokenizer = AutoTokenizer.from_pretrained(
			"badmatr11x/distilroberta-base-offensive-hateful-speech-text-multiclassification"
		)
		self.replacement_string = os.getenv("REPLACEMENT_STRING", "#")
		self.model_labels = {"HATE-SPEECH", "OFFENSIVE-LANGUAGE"}
		self.feedback_service = FeedbackService()

	def is_profanity(
		self, text: str, threshold: float = 0.5, suspicion_threshold: float = 0.3
	) -> Dict[str, List[str]]:
		result = self.classifier(text)

		print(result)

		profanity = False
		suspicion = False
		reasons = []

		for data in result:
			if data["label"] in self.model_labels:
				if data["score"] >= threshold:
					profanity = True
					reasons.append(data["label"])
				elif data["score"] >= suspicion_threshold:
					suspicion = True

		if profanity or suspicion:
			self.feedback_service.add_to_queue(
				text=text,
				detected_score=max(result, key=lambda x: x["score"])["score"],
				detected_is_offensive=profanity,
			)

		return {"is_profanity": profanity, "reasons": reasons}

	def filter_text(self, text: str) -> text_filter.v1.FilterTextResponse:
		result = self.is_profanity(text)

		# TODO: filter only profanity and not the whole text if possible
		filtered_text = (
			self.replacement_string * len(text) if result["is_profanity"] else text
		)

		return text_filter.v1.FilterTextResponse(
			filtered=result["is_profanity"],
			filtered_text=filtered_text,
			reasons=result["reasons"],
		)

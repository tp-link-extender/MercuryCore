import os

from typing import Dict, List
from transformers import pipeline, AutoTokenizer

from app.models import TextFilterResponse

# TODO: find better model, change labels
# model: https://huggingface.co/cardiffnlp/twitter-roberta-base-offensive
# model labels: https://huggingface.co/cardiffnlp/twitter-roberta-base-offensive/blob/main/config.json
class TextFilterService:
    def __init__(self):
        self.classifier = pipeline("text-classification", model="cardiffnlp/twitter-roberta-base-offensive")
        self.tokenizer = AutoTokenizer.from_pretrained("cardiffnlp/twitter-roberta-base-offensive")
        self.replacement_string = os.getenv("REPLACEMENT_STRING", "#")
        self.model_labels = {
            "offensive"
        }
    
    def is_profanity(self, text: str, threshold: float = 0.5) -> Dict[str, List[str]]:
        result = self.classifier(text)

        print(result)

        profanity = False
        reasons = []

        for data in result:
            if data["label"] in self.model_labels and data["score"] >= threshold:
                profanity = True
                reasons.append(data["label"])

        return {
            "is_profanity": profanity,
            "reasons": reasons
        }

    def filter_text(self, text: str) -> TextFilterResponse:
        result = self.is_profanity(text)

        # TODO: filter only profanity and not the whole text if possible
        filtered_text = self.replacement_string * len(text) if result["is_profanity"] else text
        
        return TextFilterResponse(
            filtered=result["is_profanity"],
            filtered_text=filtered_text,
            reasons=result["reasons"]
        )
import os


class config:
	API_DEBUG: bool = os.getenv("API_DEBUG", "false").lower() == "true"

	REDIS_HOST: str = os.getenv("REDIS_HOST", "localhost")
	REDIS_PORT: int = int(os.getenv("REDIS_PORT", 6379))
	REDIS_DB: int = int(os.getenv("REDIS_DB", 0))

	REPLACEMENT_STRING: str = os.getenv("REPLACEMENT_STRING", "#")

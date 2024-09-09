import redis
import os

REDIS_HOST = os.getenv("REDIS_HOST")
REDIS_PORT = os.getenv("REDIS_PORT")
REDIS_DB = os.getenv("REDIS_DB")


class RedisClient:
	_instance = None

	@classmethod
	def singleton(cls) -> redis.Redis:
		if cls._instance is None:
			cls._instance = redis.Redis(
				host=REDIS_HOST, port=REDIS_PORT, db=REDIS_DB, decode_responses=True
			)
		return cls._instance

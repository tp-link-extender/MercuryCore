import redis

from app.config import config


class RedisClient:
	_instance = None

	@classmethod
	def singleton(cls) -> redis.Redis:
		if cls._instance is None:
			cls._instance = redis.Redis(
				host=config.REDIS_HOST,
				port=config.REDIS_PORT,
				db=config.REDIS_DB,
				decode_responses=True,
			)
		return cls._instance

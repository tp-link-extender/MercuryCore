SELECT username
FROM user
WHERE id NOT IN (
	SELECT VALUE out
	FROM moderation
	WHERE active = true
);

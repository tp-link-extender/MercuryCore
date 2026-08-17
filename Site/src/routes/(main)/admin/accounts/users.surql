SELECT username, status FROM user
WHERE id NOT IN (
	SELECT VALUE record::id(out)
	FROM moderation
	WHERE active = true
);

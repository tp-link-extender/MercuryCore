SELECT username, status FROM user
WHERE id NOT IN (SELECT out FROM moderation WHERE active = true);

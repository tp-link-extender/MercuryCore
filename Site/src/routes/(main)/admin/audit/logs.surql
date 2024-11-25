SELECT
	action,
	note,
	time,
	(SELECT status, username FROM user)[0] AS user
FROM auditLog ORDER BY time DESC
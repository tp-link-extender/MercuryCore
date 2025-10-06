SELECT
	action,
	created,
	note,
	(SELECT status, username FROM $parent.user)[0] AS user
FROM auditLog ORDER BY created DESC;

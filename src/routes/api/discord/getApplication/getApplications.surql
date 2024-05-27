SELECT
	discordId,
	response,
	created,
	status,
	reviewed,
	reason
FROM application WHERE status = "Pending"
ORDER BY created;

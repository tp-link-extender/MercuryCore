SELECT
	response,
	created,
	status,
	reviewed,
	reason
FROM application
WHERE discordId = $id
ORDER BY created DESC LIMIT 1;

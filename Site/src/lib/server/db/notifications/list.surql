# Only the fields the notifications list shows, and relativeId, which is used to build links and then removed
SELECT
	record::id(id) AS id,
	note,
	read,
	relativeId,
	type,
	(SELECT status, username FROM $parent<-user)[0] AS sender
FROM notification WHERE out = $user
ORDER BY time DESC;

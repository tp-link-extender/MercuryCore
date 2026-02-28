SELECT
	*,
	record::id(id) AS id,
	(SELECT status, username FROM $parent<-user)[0] AS sender
OMIT in, out
FROM notification WHERE out = $user
ORDER BY time DESC;

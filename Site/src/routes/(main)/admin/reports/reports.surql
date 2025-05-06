SELECT
	category,
	note,
	time,
	url,
	record::id(id) AS id,
	(SELECT status, username FROM ->user)[0] AS reportee,
	(SELECT status, username FROM <-user)[0] AS reporter
FROM report ORDER BY time DESC;

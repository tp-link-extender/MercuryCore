SELECT
	*,
	meta::id(id) AS id,
	(SELECT number, status, username
	FROM <-owns<-user)[0] AS owner,
	(SELECT text, updated FROM $parent.description
	ORDER BY updated DESC)[0] AS description
FROM $place;

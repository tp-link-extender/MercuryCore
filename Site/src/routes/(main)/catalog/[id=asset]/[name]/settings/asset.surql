SELECT
	*,
	record::id(id) AS id,
	(SELECT status, username FROM <-created<-user)[0] AS creator,

	(SELECT text, updated FROM $parent.description
	ORDER BY updated)[$] AS description
FROM $asset;

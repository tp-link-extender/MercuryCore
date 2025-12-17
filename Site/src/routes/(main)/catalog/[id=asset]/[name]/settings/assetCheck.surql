SELECT
	*,
	record::id(id) AS id,
	SELECT VALUE record::id(id) AS id FROM <-created<-user AS creatorId,

	(SELECT text, updated FROM $parent.description
	ORDER BY updated)[$] AS description
FROM $asset;

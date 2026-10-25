SELECT
	*,
	(SELECT VALUE record::id(id) FROM $parent<-created<-user LIMIT 1)[0] AS creatorId
FROM $asset;

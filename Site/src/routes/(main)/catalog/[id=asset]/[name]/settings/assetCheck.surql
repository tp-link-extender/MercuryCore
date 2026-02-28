SELECT
	*,
	record::id(id) AS id,
	(SELECT VALUE id FROM $parent<-created<-user)[0] = $user AS isCreator,

	(SELECT text, updated FROM $parent.description
	ORDER BY updated)[$] AS description
FROM $asset;

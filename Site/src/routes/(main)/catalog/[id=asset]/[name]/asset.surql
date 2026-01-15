SELECT
	*,
	record::id(id) AS id,
	(SELECT status, username FROM <-created<-user)[0] AS creator,
	(SELECT VALUE id FROM <-created<-user)[0] = $user AS isCreator,
	count(<-ownsAsset<-user) AS sold,
	$user IN <-ownsAsset<-user.id AS owned,

	(SELECT text, updated FROM $parent.description
	ORDER BY updated)[$] AS description,

	array::flatten(
		SELECT VALUE fn::getComments($this.id, 1, $user)
		FROM comment WHERE type = ["asset", record::id($parent.id)]
	) AS comments
FROM $asset;

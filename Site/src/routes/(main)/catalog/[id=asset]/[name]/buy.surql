SELECT
	*,
	(SELECT record::id(id) AS id, username
	FROM $parent<-created<-user)[0] AS creator,
	$user IN <-ownsAsset<-user.id AS owned
FROM $asset;

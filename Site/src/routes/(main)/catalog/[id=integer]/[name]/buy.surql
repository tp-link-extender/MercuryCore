SELECT
	*,
	(SELECT record::id(id) AS id, username
	FROM <-created<-user)[0] AS creator,
	$user IN <-owns<-user.id AS owned
FROM $asset;

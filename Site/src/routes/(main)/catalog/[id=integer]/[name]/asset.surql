SELECT
	*,
	meta::id(id) AS id,
	(SELECT status, username FROM <-created<-user)[0] AS creator,
	count(<-owns<-user) AS sold,
	$user IN <-owns<-user.id AS owned,

	(SELECT text, updated FROM $parent.description
	ORDER BY updated DESC)[0] AS description,

	_SELECTCOMMENTS
FROM $asset;

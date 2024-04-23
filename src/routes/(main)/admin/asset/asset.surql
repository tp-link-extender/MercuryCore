SELECT
	meta::id(id) AS id,
	name,
	price,
	type,
	(SELECT number, status, username
	FROM <-created<-user)[0] AS creator,
	(SELECT meta::id(id) AS id, name
	FROM ->imageAsset->asset)[0] AS imageAsset
FROM asset WHERE visibility = "Pending"
	AND type IN [17, 18, 2, 11, 12, 19, 8];

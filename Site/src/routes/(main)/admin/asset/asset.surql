SELECT
	record::id(id) AS id,
	name,
	price,
	type,
	(SELECT status, username FROM <-created<-user)[0] AS creator,
	(SELECT record::id(id) AS id, name
	FROM ->imageAsset->asset)[0] AS imageAsset
FROM asset WHERE visibility = "Pending"
	AND type IN [2, 8, 11, 12, 17, 18, 19];

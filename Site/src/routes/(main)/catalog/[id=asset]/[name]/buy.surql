SELECT
	*,
	record::id(<-created[0]<-user[0].id) AS creatorId
FROM $asset;

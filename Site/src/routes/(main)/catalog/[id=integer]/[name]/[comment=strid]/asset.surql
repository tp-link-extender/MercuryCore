SELECT
	name,
	(SELECT username FROM <-created<-user)[0] AS creator
FROM $asset;

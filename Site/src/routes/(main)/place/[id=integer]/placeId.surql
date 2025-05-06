SELECT
	name,
	privateServer,
	record::id(id) AS id,
	(SELECT record::id(id) AS id FROM <-ownsPlace<-user)[0] AS owner
FROM $place;

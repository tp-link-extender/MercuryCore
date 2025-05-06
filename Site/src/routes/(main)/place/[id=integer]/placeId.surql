SELECT
	name,
	privateServer,
	record::id(id) AS id,
	(SELECT record::id(id) AS id FROM <-owns<-user)[0] AS owner
FROM $place;

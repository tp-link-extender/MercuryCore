SELECT
	name,
	privateServer,
	meta::id(id) AS id,
	(SELECT meta::id(id) AS id FROM <-owns<-user)[0] AS owner
FROM $place;

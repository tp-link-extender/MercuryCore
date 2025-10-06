SELECT
	name,
	(SELECT VALUE id FROM <-ownsPlace<-user)[0] AS ownerId,
	privateServer
FROM $place;

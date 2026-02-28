SELECT
	name,
	(SELECT VALUE id FROM $parent<-ownsPlace<-user)[0] AS ownerId,
	privateServer
FROM $place;

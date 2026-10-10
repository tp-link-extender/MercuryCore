SELECT
	privateServer,
	privateTicket,
	clientVersion,
	(SELECT username FROM $parent<-ownsPlace<-user)[0].username AS ownerUsername
FROM $place;

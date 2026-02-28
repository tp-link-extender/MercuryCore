SELECT
	privateServer,
	privateTicket,
	(SELECT username FROM $parent<-ownsPlace<-user)[0].username AS ownerUsername
FROM $place;

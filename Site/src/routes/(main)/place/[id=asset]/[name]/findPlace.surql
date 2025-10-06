SELECT
	privateServer,
	privateTicket,
	(SELECT username FROM <-ownsPlace<-user)[0].username AS ownerUsername
FROM $place;

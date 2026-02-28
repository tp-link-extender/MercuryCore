SELECT
	dedicated,
	(SELECT text, updated FROM $parent.description
	ORDER BY updated)[$] AS description,
	record::id(id) AS id,
	maxPlayers,
	name,
	(SELECT status, username FROM $parent<-ownsPlace<-user)[0] AS owner,
	privateServer,
	privateTicket,
	serverAddress,
	serverPort,
	serverTicket
FROM $place;

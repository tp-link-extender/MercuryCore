SELECT
	dedicated,
	fn::currentContent($this.description) AS description,
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

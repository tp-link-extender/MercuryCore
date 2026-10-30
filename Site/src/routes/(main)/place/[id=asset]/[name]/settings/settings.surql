SELECT
	dedicated,
	fn::currentContent($this.description) AS description,
	record::id(id) AS id,
	maxPlayers,
	name,
	clientVersion,
	privateServer,
	privateTicket,
	serverAddress,
	serverPort,
	serverTicket
FROM $place;

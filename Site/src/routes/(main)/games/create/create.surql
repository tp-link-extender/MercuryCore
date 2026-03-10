LET $place = CREATE ONLY place CONTENT {
	id: $id,
	description: [{
		text: $description,
	}],
	maxPlayers: $maxPlayers,
	name: $name,
	privateServer: $privateServer,
	serverAddress: $serverAddress,
	serverPort: $serverPort,
};
RELATE $user->ownsPlace->$place;

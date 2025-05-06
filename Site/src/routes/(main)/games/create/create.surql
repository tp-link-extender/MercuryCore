LET $place = CREATE place CONTENT {
	id: $id,
	description: [{
		text: $description,
		updated: time::now(),
	}],
	maxPlayers: $maxPlayers,
	name: $name,
	privateServer: $privateServer,
	serverIP: $serverIP,
	serverPort: $serverPort,
	serverPing: 0,
};
RELATE $user->owns->$place;

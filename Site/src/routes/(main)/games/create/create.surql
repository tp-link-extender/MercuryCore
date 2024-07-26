LET $place = CREATE place CONTENT {
	id: $id,
	name: $name,
	description: [{
		text: $description,
		updated: time::now(),
	}],
	serverIP: $serverIP,
	serverPort: $serverPort,
	privateServer: $privateServer,
	serverTicket: rand::guid(),
	privateTicket: rand::guid(),
	serverPing: 0,
	maxPlayers: $maxPlayers,
	created: time::now(),
	updated: time::now(),
	deleted: false,
};
RELATE $user->owns->$place;

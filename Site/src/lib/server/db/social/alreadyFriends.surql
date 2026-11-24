$user IN $user2->friends->user
	OR $user2 IN $user->friends->user;

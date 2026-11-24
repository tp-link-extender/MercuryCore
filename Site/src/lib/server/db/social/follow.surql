IF $user2 NOT IN $user->follows->user {
	RELATE $user->follows->$user2;
	fn::notify($user, $user2, "Follower", $note, $relativeId);
};

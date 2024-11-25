IF $user2 NOT IN $user->follows->user {
	RELATE $user->follows->$user2 SET time = time::now();
	fn::notify($user, $user2, "Follower", $note, $relativeId);
};

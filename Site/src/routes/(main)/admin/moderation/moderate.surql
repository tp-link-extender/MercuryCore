RELATE $user->moderation->$moderatee CONTENT {
	note: $reason,
	type: $moderationAction,
	time: time::now(),
	timeEnds: $timeEnds,
	active: true,
};

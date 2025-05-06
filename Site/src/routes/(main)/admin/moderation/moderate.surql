RELATE $user->moderation->$moderatee CONTENT {
	active: true,
	note: $reason,
	timeEnds: $timeEnds,
	type: $moderationAction,
};

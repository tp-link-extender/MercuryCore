LET $s = CREATE ONLY session SET expiresAt = time::now() + 30d;
RELATE $user->hasSession->$s;

{
	id: record::id($s.id),
	user: record::id($user.id),
	expiresAt: $s.expiresAt,
};

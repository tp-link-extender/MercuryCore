LET $u = CREATE ONLY user CONTENT {
	admin: $admin,
	bodyColours: $bodyColours,
	email: $email,
	hashedPassword: $hashedPassword,
	permissionLevel: $permissionLevel,
	username: $username,
} RETURN VALUE id;
# Return some user data
$u;

IF $key {
	UPDATE $key SET usesLeft -= 1;
	RELATE $u->used->$key;
};

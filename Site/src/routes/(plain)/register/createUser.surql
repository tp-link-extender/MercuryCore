LET $u = CREATE ONLY user CONTENT {
	bodyColours: $bodyColours,
	email: IF $key { $email } ELSE { "" },
	hashedPassword: $hashedPassword,
	permissionLevel: IF $key { 1 } ELSE { 5 },
	username: $username,
} RETURN VALUE id;
# Return some user data
$u;

IF $key {
	UPDATE $key SET usesLeft -= 1;
	RELATE $u->used->$key;
};

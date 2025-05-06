CREATE user CONTENT {
	bodyColours: $bodyColours,
	email: IF $admin THEN "" ELSE $email END,
	hashedPassword: $hashedPassword,
	permissionLevel: IF $admin { 5 } ELSE { 1 },
	username: $username,
};
# Return some user data
LET $u = (SELECT id FROM user WHERE username = $username)[0].id;
record::id($u);

IF $key {
	UPDATE $key SET usesLeft -= 1;
	RELATE $u->used->$key;
};

CREATE user CONTENT {
	bio: [],
	bodyColours: $bodyColours,
	created: time::now(),
	css: "",
	email: IF $admin THEN "" ELSE $email END,
	hashedPassword: $hashedPassword,
	lastOnline: time::now(),
	permissionLevel: IF $admin { 5 } ELSE { 1 },
	theme: 0,
	username: $username,
};
# Return some user data
LET $u = (SELECT id FROM user WHERE username = $username)[0].id;
record::id($u);

IF $key {
	UPDATE $key SET usesLeft -= 1;
	RELATE $u->used->$key;
};

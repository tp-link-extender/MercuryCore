CREATE user CONTENT {
	bio: [],
	bodyColours: $bodyColours,
	created: time::now(),
	css: "",
	email: IF $admin THEN "" ELSE $email END,
	hashedPassword: $hashedPassword,
	lastOnline: time::now(),
	permissionLevel: IF $admin THEN 5 ELSE 1 END,
	status: <future> {
		IF ->playing[WHERE valid AND ping > time::now() - 35s] THEN
			"Playing"
		ELSE IF lastOnline > time::now() - 35s THEN
			"Online"
		ELSE
			"Offline"
		END
	},
	theme: 0,
	username: $username,
};
# Return some user data
LET $u = (SELECT id FROM user WHERE username = $username)[0].id;
meta::id($u);

IF $key {
	UPDATE $key SET usesLeft -= 1;
	RELATE $u->used->$key;
};

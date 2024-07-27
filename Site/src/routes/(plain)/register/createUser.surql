CREATE user CONTENT {
	bio: [],
	bodyColours: $bodyColours,
	created: time::now(),
	css: "",
	email: $user.email,
	hashedPassword: $user.hashedPassword,
	lastOnline: time::now(),
	permissionLevel: 1,
	status: <future> {
		IF ->playing[WHERE valid AND ping > time::now() - 35s] THEN
			"Playing"
		ELSE IF lastOnline > time::now() - 35s THEN
			"Online"
		ELSE
			"Offline"
		END
	},
	username: $user.username,
};
# Return some user data
LET $u = (SELECT id FROM user WHERE username = $user.username)[0].id;
meta::id($u);

UPDATE ONLY $key SET usesLeft -= 1;
RELATE $u->used->$key;

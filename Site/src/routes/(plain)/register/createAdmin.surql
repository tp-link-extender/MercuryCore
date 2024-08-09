CREATE user CONTENT {
	bio: [],
	bodyColours: $bodyColours,
	created: time::now(),
	css: "",
	email: "",
	hashedPassword: $hashedPassword,
	lastOnline: time::now(),
	permissionLevel: 5,
	status: <future> {
		IF ->playing[WHERE valid AND ping > time::now() - 35s] THEN
			"Playing"
		ELSE IF lastOnline > time::now() - 35s THEN
			"Online"
		ELSE
			"Offline"
		END
	},
	username: $username,
};
# Return some user data
LET $u = (SELECT id FROM user WHERE username = $username)[0].id;
meta::id($u);

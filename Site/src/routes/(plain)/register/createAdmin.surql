CREATE user CONTENT {
	bio: [],
	bodyColours: {
		Head: 24,
		Torso: 23,
		LeftArm: 24,
		RightArm: 24,
		LeftLeg: 119,
		RightLeg: 119,
	},
	created: time::now(),
	css: "",
	currencyCollected: time::now(),
	email: "",
	hashedPassword: $user.hashedPassword,
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
	username: $user.username,
};
# Return some user data
LET $u = (SELECT id FROM user WHERE username = $user.username)[0].id;
meta::id($u);

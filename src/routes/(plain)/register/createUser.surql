# Assign $number to a variable, otherwise when it's returned it will increment the number by 2 instead of 1 (?????????)
LET $number = (UPDATE ONLY stuff:increment SET user += 1).user;
UPDATE (CREATE user CONTENT $user)[0] MERGE {
	theme: "standard",
	created: time::now(),
	currencyCollected: time::now(),
	bio: [],
	bodyColours: {
		Head: 24,
		Torso: 23,
		LeftArm: 24,
		RightArm: 24,
		LeftLeg: 119,
		RightLeg: 119,
	},
	status: <future> {
		(IF (SELECT 1 FROM ->playing
			WHERE valid AND ping > time::now() - 35s
		)[0] THEN
			"Playing"
		ELSE IF lastOnline > time::now() - 35s THEN
			"Online"
		ELSE
			"Offline"
		END)
	},
	number: $number,
};
LET $u = (SELECT number, id FROM user
	WHERE username = $user.username)[0];
# Return some user data
{
	id: meta::id($u.id),
	number: $number,
};

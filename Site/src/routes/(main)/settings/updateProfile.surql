LET $og = SELECT
	(SELECT text, updated FROM $parent.bio
	ORDER BY updated)[$] AS bio
FROM $user;

UPDATE $user SET theme = $theme;

IF $og.bio.text != $bio {
	UPDATE $user SET bio += {
		text: $bio,
		updated: time::now(),
	}
};

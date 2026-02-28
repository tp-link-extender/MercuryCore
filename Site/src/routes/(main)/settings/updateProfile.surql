LET $og = SELECT
	(SELECT text, updated FROM $parent.description
	ORDER BY updated)[$] AS description
FROM $user;

UPDATE $user SET theme = $theme;

IF $og.description.text != $description {
	UPDATE $user SET description += {
		text: $description,
	}
};

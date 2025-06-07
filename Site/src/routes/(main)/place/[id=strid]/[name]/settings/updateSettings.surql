LET $og = SELECT
	(SELECT text, updated FROM $parent.description
	ORDER BY updated)[$] AS description
FROM $place;

UPDATE $place SET name = $name;

IF $og.description.text != $description {
	UPDATE $place SET description += {
		text: $description,
		updated: time::now(),
	};
};

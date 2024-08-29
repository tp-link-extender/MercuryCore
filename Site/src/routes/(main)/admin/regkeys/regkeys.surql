SELECT
	*,
	meta::id(id) AS id,
	(SELECT status, username FROM $parent.creator)[0] AS creator
FROM regKey ORDER BY creation DESC;

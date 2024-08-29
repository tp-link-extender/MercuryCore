SELECT
	meta::id(id) AS id,
	created,
	usesLeft,
	expiry,
	(SELECT status, username FROM $parent.creator)[0] AS creator
FROM regKey ORDER BY created DESC;

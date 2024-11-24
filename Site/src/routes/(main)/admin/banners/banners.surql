SELECT
	*,
	meta::id(id) AS id,
	(SELECT status, username FROM $parent.creator)[0] AS creator
OMIT deleted
FROM banner WHERE !deleted;

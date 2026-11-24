# Only the fields the banner list shows
SELECT
	active,
	bgColour,
	body,
	record::id(id) AS id,
	(SELECT status, username FROM $parent.creator)[0] AS creator,
	textLight
FROM banner WHERE !deleted;

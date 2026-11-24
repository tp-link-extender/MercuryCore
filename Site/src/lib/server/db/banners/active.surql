SELECT
	body,
	bgColour,
	textLight,
	record::id(id) AS id
OMIT deleted
FROM banner WHERE !deleted AND active
SELECT
	body,
	bgColour,
	textLight,
	meta::id(id) AS id
OMIT deleted
FROM banner WHERE !deleted AND active
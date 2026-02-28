SELECT
	bodyColours,
	(SELECT record::id(id) AS id
	FROM $parent->wearing->asset).id AS wearing
FROM user WHERE username = $username;

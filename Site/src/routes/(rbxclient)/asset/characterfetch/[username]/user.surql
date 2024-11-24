SELECT
	bodyColours,
	(SELECT meta::id(id) AS id
	FROM ->wearing->asset).id AS wearing
FROM user WHERE username = $username;

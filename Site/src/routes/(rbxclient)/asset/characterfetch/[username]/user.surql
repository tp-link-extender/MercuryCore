SELECT
	bodyColours,
	(SELECT VALUE record::id(id)
	FROM ->wearing->asset) AS wearing
FROM user WHERE username = $username;

SELECT
	bodyColours,
	SELECT VALUE record::id(id) FROM $this->wearing->asset AS wearing
FROM user WHERE username = $username;

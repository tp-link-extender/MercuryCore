SELECT
	record::id(id) AS id,
	type,
	status,
	created,
	completed,
	relativeId,
	IF $parent.type = "Avatar" {
		SELECT status, username FROM user WHERE number = $parent.relativeId
	}[0] AS user,
	IF $parent.type = "Clothing" {
		SELECT
			record::id(id) AS id,
			name
		FROM asset WHERE id = $parent.relativeId
	}[0] AS asset
FROM render ORDER BY created DESC;

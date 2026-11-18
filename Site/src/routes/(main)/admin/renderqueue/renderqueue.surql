SELECT
	record::id(id) AS id,
	type,
	status,
	created,
	completed,
	relativeId,
	IF $parent.type = "Avatar" {
		SELECT status, username FROM user WHERE record::id(id) = $parent.relativeId
	}[0] AS user,
	IF $parent.type != "Avatar" {
		SELECT
			record::id(id) AS id,
			name
		FROM asset WHERE record::id(id) = $parent.relativeId
	}[0] AS asset
FROM render ORDER BY created DESC;

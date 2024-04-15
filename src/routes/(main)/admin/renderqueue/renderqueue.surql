SELECT
	meta::id(id) AS id,
	type,
	status,
	created,
	completed,
	relativeId,
	IF $parent.type = "Avatar" THEN
		SELECT number, status, username
		FROM user WHERE number = $parent.relativeId
	END[0] AS user,
	IF $parent.type = "Clothing" THEN
		SELECT
			meta::id(id) AS id,
			name
		FROM asset WHERE id = $parent.relativeId
	END[0] AS asset
FROM render ORDER BY created DESC;

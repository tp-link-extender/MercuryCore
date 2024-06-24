SELECT
	name,
	count(<-member) AS memberCount
FROM group
WHERE string::lowercase($query) IN string::lowercase(name);

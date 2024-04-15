SELECT
	name,
	count(<-member) AS memberCount
FROM group
WHERE string::lowercase($searchQ) INSIDE string::lowercase(name);

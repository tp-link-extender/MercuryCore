SELECT
	name,
	count(<-member) AS memberCount
FROM group
WHERE string::lowercase($searchQ) IN string::lowercase(name);

SELECT
	name,
	count(<-member) AS memberCount
FROM group WHERE name ~ $query;

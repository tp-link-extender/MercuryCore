SELECT
	meta::id(id) AS id,
	name,
	count(<-member) AS memberCount
FROM group WHERE name ~ $query;

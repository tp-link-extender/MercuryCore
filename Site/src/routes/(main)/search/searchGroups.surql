SELECT
	record::id(id) AS id,
	name,
	count(<-member) AS memberCount
FROM group WHERE name ~ $query;

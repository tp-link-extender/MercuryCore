SELECT
	name,
	count(<-member) AS memberCount,
	(SELECT number, status, username
	FROM <-member<-user) AS members
FROM group
WHERE string::lowercase(name) = string::lowercase($name);

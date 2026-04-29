SELECT
	name,
	count(<-member) AS memberCount,
	(SELECT status, username FROM $parent<-member<-user) AS members
FROM $group;

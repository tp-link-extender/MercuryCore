SELECT
	name,
	count(<-member) AS memberCount,
	(SELECT status, username FROM <-member<-user) AS members
FROM $group;

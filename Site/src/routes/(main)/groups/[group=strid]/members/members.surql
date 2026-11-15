SELECT
	name,
	count(array::distinct(<-member<-user)) AS memberCount,
	(SELECT status, username FROM array::distinct($parent<-member<-user)) AS members
FROM $group;

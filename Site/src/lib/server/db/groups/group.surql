SELECT
	record::id(id) AS id,
	name,
	count(array::distinct(<-member<-user)) AS memberCount,
	$user IN <-member<-user.id AS in
FROM $group;

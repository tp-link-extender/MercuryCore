SELECT
	record::id(id) AS id,
	name,
	count(<-member) AS memberCount,
	$user IN <-member<-user.id AS in
FROM $group;

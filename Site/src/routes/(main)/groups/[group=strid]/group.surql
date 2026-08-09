SELECT
	record::id(id) AS id,
	name,
	count(<-member) AS memberCount,
	$user IN <-member<-user.id AS in
	# [] AS places,
	# [] AS feed
FROM $group;

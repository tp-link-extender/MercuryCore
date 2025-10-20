SELECT
	record::id(id) AS id,
	name,
	(SELECT status, username FROM <-ownsGroup<-user)[0] AS owner,
	count(<-member) AS memberCount,
	$user IN <-member<-user.id AS in
	# [] AS places,
	# [] AS feed
FROM $group;

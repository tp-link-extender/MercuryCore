SELECT
	record::id(id) AS id,
	name,
	count(<-member) AS memberCount,
	$user IN <-member<-user.id AS in,
	(SELECT status, username FROM $this<-member<-user)[0] AS owner
	# [] AS places,
	# [] AS feed
FROM $group;

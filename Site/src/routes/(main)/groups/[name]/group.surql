SELECT
	name,
	(SELECT status, username FROM <-owns<-user)[0] AS owner,
	count(<-member) AS memberCount,
	$user IN <-member<-user.id AS in
	# [] AS places,
	# [] AS feed
FROM group
WHERE string::lowercase(name) = string::lowercase($name);

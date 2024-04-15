SELECT
	meta::id(id) AS id,
	name,
	(SELECT text, updated FROM $parent.description
	ORDER BY updated DESC)[0] AS description,
	serverPing,
	serverTicket,
	privateServer,
	privateTicket,
	created,
	updated,
	maxPlayers,
	(SELECT username, status, number
	FROM <-owns<-user)[0] AS ownerUser,
	(SELECT
		in.username AS username,
		"Playing" AS status, # duh
		in.number AS number
	FROM <-playing
	WHERE valid AND ping > time::now() - 35s) AS players,

	count((SELECT * FROM $parent<-likes).in) AS likeCount,
	count((SELECT * FROM $parent<-dislikes).in) AS dislikeCount,
	$user INSIDE (SELECT * FROM $parent<-likes).in AS likes,
	$user INSIDE (SELECT * FROM $parent<-dislikes).in AS dislikes
FROM $place;

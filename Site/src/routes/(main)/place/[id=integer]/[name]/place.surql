SELECT
	record::id(id) AS id,
	name,
	(SELECT text, updated FROM $parent.description
	ORDER BY updated)[$] AS description,
	serverPing,
	serverTicket,
	privateServer,
	privateTicket,
	created,
	updated,
	maxPlayers,
	(SELECT username, status
	FROM <-owns<-user)[0] AS ownerUser,
	(SELECT
		in.username AS username,
		"Playing" AS status # duh
	FROM <-playing
	WHERE valid AND ping > time::now() - 35s) AS players,

	count(SELECT 1 FROM $parent<-likes) AS likeCount,
	count(SELECT 1 FROM $parent<-dislikes) AS dislikeCount,
	$user IN (SELECT * FROM $parent<-likes).in AS likes,
	$user IN (SELECT * FROM $parent<-dislikes).in AS dislikes
FROM $place;

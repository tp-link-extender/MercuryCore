SELECT
	record::id(id) AS id,
	name,
	serverPing,
	count(
		SELECT 1 FROM <-playing WHERE valid AND ping > time::now() - 35s
	) AS playerCount,
	count(<-likes) AS likeCount,
	count(<-dislikes) AS dislikeCount
FROM place WHERE !privateServer AND !deleted;

# Friends
SELECT status, username FROM $user->friends->user OR $user<-friends<-user;

# Feed
SELECT
	*,
	record::id(id) AS id,
	(SELECT text, updated FROM $parent.content
	ORDER BY updated)[$].text AS currentContent
FROM comment WHERE type = ["status"]
ORDER BY created DESC
LIMIT 40;

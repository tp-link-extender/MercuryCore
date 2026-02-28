SELECT
	record::id(id) AS id,
	name,
	serverPing,
	count(
		SELECT 1 FROM $parent<-playing
		WHERE valid AND ping > time::now() - 35s
	) AS playerCount,
	count(<-likes) AS likeCount,
	count(<-dislikes) AS dislikeCount
FROM place WHERE fn::filterGames($this)
ORDER BY playerCount DESC, serverPing DESC
LIMIT 50 START ($page - 1) * 50;

fn::clampPages(
	count(SELECT 1 FROM place WHERE fn::filterGames($this)),
	50
);


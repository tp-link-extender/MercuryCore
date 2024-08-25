SELECT
	meta::id(id) AS id,
	name,
	serverPing,
	count(
		SELECT 1 FROM <-playing
		WHERE valid AND ping > time::now() - 35s
	) AS playerCount,
	count(<-likes) AS likeCount,
	count(<-dislikes) AS dislikeCount
FROM place WHERE !privateServer
	AND !deleted
	AND IF $query THEN
		string::lowercase($query) IN string::lowercase(name)
	ELSE
		TRUE
	END
ORDER BY playerCount DESC, serverPing DESC
LIMIT 50 START ($page - 1) * 50;

math::max([
	math::ceil(<float> count(SELECT 1 FROM place WHERE !privateServer
		AND !deleted
		AND IF $query THEN
			string::lowercase($query) IN string::lowercase(name)
		ELSE
			TRUE
		END) / 50),
	1
]);


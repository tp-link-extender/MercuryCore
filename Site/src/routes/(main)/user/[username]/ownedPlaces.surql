SELECT
	record::id(id) AS id,
	name,
	count(
		SELECT 1 FROM $parent<-playing WHERE valid AND ping > time::now() - 35s
	) AS playerCount,
	count(<-likes) AS likeCount,
	count(<-dislikes) AS dislikeCount
FROM place WHERE id IN $ids;

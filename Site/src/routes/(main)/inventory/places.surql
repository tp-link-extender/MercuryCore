$is.map(|$i|
	SELECT
		record::id(id) AS id,
		name,
		count(SELECT 1 FROM $parent<-likes) AS likeCount,
		count(SELECT 1 FROM $parent<-dislikes) AS dislikeCount,
		count(
			SELECT 1 FROM $parent<-playing
			WHERE valid AND ping > time::now() - 35s
		) AS playerCount
	FROM $i
);

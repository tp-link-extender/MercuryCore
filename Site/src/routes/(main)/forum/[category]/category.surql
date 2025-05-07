(SELECT
	*,
	record::id(id) AS id,
	(SELECT
		*,
		record::id(id) AS id,
		(SELECT text, updated FROM $parent.content
		ORDER BY updated DESC) AS content,
		(SELECT status, username FROM <-created<-user)[0] AS author,
		count(<-likes) - count(<-dislikes) AS score,
		($user IN <-likes<-user.id) AS likes,
		($user IN <-dislikes<-user.id) AS dislikes
	FROM $parent<-in.in
	ORDER BY pinned DESC, score DESC
	LIMIT 15 START ($page - 1) * 15) AS posts
FROM forumCategory
WHERE string::lowercase(record::id(id)) = string::lowercase($category))[0];

math::max([
	(SELECT
		math::ceil(<float> count(SELECT 1 FROM $parent<-in.in) / 15) AS count
	FROM forumCategory 
	WHERE string::lowercase(record::id(id)) = string::lowercase($category))[0].count,
	1
]);

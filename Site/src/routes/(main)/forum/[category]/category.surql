SELECT
	*,
	(SELECT
		*,
		meta::id(id) AS id,
		(SELECT text, updated FROM $parent.content
		ORDER BY updated DESC) AS content,
		(SELECT status, username FROM <-created<-user)[0] AS author,
		count(<-likes) - count(<-dislikes) AS score,
		($user IN <-likes<-user.id) AS likes,
		($user IN <-dislikes<-user.id) AS dislikes
	FROM $parent<-in.in
	ORDER BY pinned DESC, score DESC
	LIMIT 50 START ($page - 1) * 50) AS posts
OMIT id
FROM forumCategory
WHERE string::lowercase(name) = string::lowercase($category);

math::max([
	math::ceil(<float> 
		(SELECT
			count(SELECT 1 FROM parent<-in.in) AS count
		FROM forumCategory 
		WHERE string::lowercase(name) = string::lowercase($category)).count / 50),
	1
]);

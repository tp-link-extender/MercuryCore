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
	ORDER BY pinned DESC, score DESC) AS posts
OMIT id
FROM forumCategory
WHERE string::lowercase(name) = string::lowercase($category);

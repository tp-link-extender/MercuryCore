SELECT
	*,
	meta::id(id) AS id,
	(SELECT number, username FROM <-created<-user)[0] AS author,
	count(<-likes) - count(<-dislikes) AS score,
	$user IN <-likes<-user.id AS likes,
	$user IN <-dislikes<-user.id AS dislikes,
	(->in->forumCategory)[0].name AS categoryName,

	_SELECTREPLIES
FROM $forumPost;

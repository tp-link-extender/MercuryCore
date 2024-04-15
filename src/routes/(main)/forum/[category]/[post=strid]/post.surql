SELECT
	*,
	meta::id(id) AS id,
	(SELECT number, username FROM <-posted<-user)[0] AS author,
	count(<-likes) - count(<-dislikes) AS score,
	$user INSIDE <-likes<-user.id AS likes,
	$user INSIDE <-dislikes<-user.id AS dislikes,
	(->in->forumCategory)[0].name AS categoryName,

	_SELECTREPLIES
FROM $forumPost;

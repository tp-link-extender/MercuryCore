SELECT
	*,
	(SELECT text, updated FROM $parent.content
	ORDER BY updated DESC) AS content,
	meta::id(id) AS id,
	$forumPost AS parentPost,
	(IF ->replyToReply->forumReply.id THEN
		meta::id(->replyToReply[0]->forumReply[0].id)
	END) AS parentReplyId,
	(SELECT status, username FROM <-created<-user)[0] AS author,

	count(<-likes) - count(<-dislikes) AS score,
	$user IN <-likes<-user.id AS likes,
	$user IN <-dislikes<-user.id AS dislikes,

	(SELECT
		title,
		meta::id(id) AS id,
		->in[0]->forumCategory[0].name as forumCategoryName
	FROM $forumPost)[0] AS parentPost,

	_SELECTREPLIES
FROM $forumReply;

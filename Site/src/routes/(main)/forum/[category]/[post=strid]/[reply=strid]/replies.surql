SELECT
	*,
	(SELECT text, updated FROM $parent.content
	ORDER BY updated DESC) AS content,
	record::id(id) AS id,
	$forumPost AS parentPost,
	(IF ->replyToReply->forumReply.id THEN
		record::id(->replyToReply[0]->forumReply[0].id)
	END) AS parentReplyId,
	(SELECT status, username FROM <-created<-user)[0] AS author,

	count(<-likes) - count(<-dislikes) AS score,
	$user IN <-likes<-user.id AS likes,
	$user IN <-dislikes<-user.id AS dislikes,

	(SELECT
		title,
		record::id(id) AS id,
		->in[0]->forumCategory[0].name as forumCategoryName
	FROM $forumPost)[0] AS parentPost,

    fn::getReplies(id, 1, $user) AS replies
FROM $forumReply;

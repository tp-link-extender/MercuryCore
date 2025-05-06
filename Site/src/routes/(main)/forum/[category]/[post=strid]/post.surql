SELECT
	*,
	record::id(id) AS id,
	(SELECT status, username FROM <-created<-user)[0] AS author,
	count(<-likes) - count(<-dislikes) AS score,
	$user IN <-likes<-user.id AS likes,
	$user IN <-dislikes<-user.id AS dislikes,
	(->in->forumCategory)[0].name AS categoryName,

    (SELECT
    	*,
		(SELECT text, updated FROM $parent.content
		ORDER BY updated DESC) AS content,
		record::id(id) AS id,
		NONE AS parentReplyId,
		(SELECT status, username FROM <-created<-user)[0] AS author,

		count(<-likes) - count(<-dislikes) AS score,
		$user IN <-likes<-user.id AS likes,
		$user IN <-dislikes<-user.id AS dislikes,

        fn::getReplies(id, 1, $user) AS replies
    FROM <-replyToPost<-forumReply WHERE !->replyToReply
	ORDER BY pinned DESC, score DESC) AS replies
FROM $forumPost;

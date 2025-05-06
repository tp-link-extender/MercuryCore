SELECT
	*,
	(SELECT text, updated FROM $parent.content
	ORDER BY updated DESC) AS content,
	record::id(id) AS id,
	(IF ->replyToComment->assetComment.id THEN
		record::id(->replyToComment[0]->assetComment[0].id)
	END) AS parentReplyId,
	(SELECT username FROM <-created<-user)[0] AS author,

	count(<-likes) - count(<-dislikes) AS score,
	$user IN <-likes<-user.id AS likes,
	$user IN <-dislikes<-user.id AS dislikes,

	(SELECT
		title,
		record::id(id) AS id,
		->in[0]->forumCategory[0].name as forumCategoryName
	FROM $asset)[0] AS parentPost,

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
    FROM <-replyToAsset<-assetComment WHERE !->replyToComment
	ORDER BY pinned DESC, score DESC) AS replies
FROM $assetComment;

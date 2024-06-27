SELECT
	*,
	(SELECT text, updated FROM $parent.content
	ORDER BY updated DESC) AS content,
	meta::id(id) AS id,
	(IF ->replyToComment->assetComment.id THEN
		meta::id(->replyToComment[0]->assetComment[0].id)
	END) AS parentReplyId,
	(SELECT number, username FROM <-posted<-user)[0] AS author,

	count(<-likes) - count(<-dislikes) AS score,
	$user IN <-likes<-user.id AS likes,
	$user IN <-dislikes<-user.id AS dislikes,

	(SELECT
		title,
		meta::id(id) AS id,
		->in[0]->forumCategory[0].name as forumCategoryName
	FROM $asset)[0] AS parentPost,

	_SELECTCOMMENTS
FROM $assetComment;

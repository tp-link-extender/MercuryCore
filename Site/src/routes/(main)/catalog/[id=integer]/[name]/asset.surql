SELECT
	*,
	meta::id(id) AS id,
	(SELECT status, username FROM <-created<-user)[0] AS creator,
	count(<-owns<-user) AS sold,
	$user IN <-owns<-user.id AS owned,

	(SELECT text, updated FROM $parent.description
	ORDER BY updated)[$] AS description,

    (SELECT
    	*,
		(SELECT text, updated FROM $parent.content
		ORDER BY updated DESC) AS content,
		meta::id(id) AS id,
		NONE AS parentReplyId,
		(SELECT status, username FROM <-created<-user)[0] AS author,

		count(<-likes) - count(<-dislikes) AS score,
		$user IN <-likes<-user.id AS likes,
		$user IN <-dislikes<-user.id AS dislikes,

        fn::getReplies(id, 1, $user) AS replies
    FROM <-replyToAsset<-assetComment WHERE !->replyToComment
	ORDER BY pinned DESC, score DESC) AS replies
FROM $asset;

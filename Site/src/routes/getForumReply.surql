SELECT
	meta::id(id) AS id,
	(SELECT
		meta::id(id) AS id,
		(->in->forumCategory)[0].name as categoryName
	FROM ->replyToPost[0]->forumPost)[0] AS parentPost
FROM $forumReply;

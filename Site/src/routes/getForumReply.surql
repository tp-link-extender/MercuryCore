SELECT
	record::id(id) AS id,
	(SELECT
		record::id(id) AS id,
		record::id((->in->forumCategory)[0].id) as categoryId
	FROM ->replyToPost[0]->forumPost)[0] AS parentPost
FROM $forumReply;

SELECT
	record::id(id) AS id,
	description,
	(SELECT
		record::id(id) AS id,
		title,
		created,
		(SELECT status, username FROM <-created<-user)[0] AS author
	FROM <-in<-forumPost
	ORDER BY created)[$] AS latestPost,
	count(<-in) AS postCount
FROM forumCategory;

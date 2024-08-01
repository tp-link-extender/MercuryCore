SELECT
	name,
	description,
	(SELECT
		meta::id(id) AS id,
		title,
		posted,
		(SELECT status, username FROM <-posted<-user)[0] AS author
	FROM <-in<-forumPost
	ORDER BY posted DESC)[0] AS latestPost,
	count(<-in) AS postCount
FROM forumCategory;

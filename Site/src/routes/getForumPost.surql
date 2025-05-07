SELECT
	(SELECT record::id(id) AS id FROM ->in->forumCategory) AS category
FROM $forumPost;

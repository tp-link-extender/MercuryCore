SELECT
	(SELECT name FROM ->in->forumCategory) AS category
FROM $forumPost;

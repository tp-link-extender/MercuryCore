SELECT
	(SELECT username FROM <-created<-user)[0] AS author
FROM $forumPost;

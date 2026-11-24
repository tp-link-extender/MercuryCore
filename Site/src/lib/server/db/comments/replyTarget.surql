SELECT
	record::id(<-createdComment[0]<-user[0].id) AS creatorId,
	type
FROM ONLY $comment WHERE visibility = "Visible";

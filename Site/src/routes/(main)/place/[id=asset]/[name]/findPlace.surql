SELECT
	privateServer,
	privateTicket,
	count(SELECT 1 FROM $parent<-likes) AS likeCount,
	count(SELECT 1 FROM $parent<-dislikes) AS dislikeCount
FROM $place;

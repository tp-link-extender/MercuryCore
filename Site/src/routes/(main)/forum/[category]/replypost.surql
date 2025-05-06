SELECT
	record::id(id) AS id,
	count(<-likes) - count(<-dislikes) AS score
FROM $replypost;

SELECT
	meta::id(id) AS id,
	count(<-likes) - count(<-dislikes) AS score
FROM $replypost;

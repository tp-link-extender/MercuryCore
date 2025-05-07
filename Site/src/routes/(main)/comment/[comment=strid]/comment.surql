SELECT
	author,
	(SELECT text, updated FROM $parent.content
	ORDER BY updated) AS content,
	created,
	dislikes,
	likes,
	pinned,
	[] AS replies,
	score,
	type,
	visibility
FROM $comment
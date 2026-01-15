(SELECT
	name,
	(SELECT
		record::id(id) AS id,
		author,
		created,
		dislikes,
		likes,
		pinned,
		score,
		visibility,
		(SELECT text, updated FROM $parent.content
		ORDER BY updated)[$].text AS currentContent
	FROM comment WHERE type = ["forum", record::id($parent.id)]
		AND visibility = "Visible"
	ORDER BY pinned DESC, score DESC
	LIMIT 15 START ($page - 1) * 15) AS posts
FROM forumCategory
WHERE string::lowercase(name) = string::lowercase($category))[0];

math::max([
	(SELECT VALUE
		math::ceil(<float> count(
			SELECT 1 FROM comment
			WHERE type = ["forum", record::id($parent.id)]
				AND visibility = "Visible"
		) / 15)
	FROM forumCategory 
	WHERE string::lowercase(name) = string::lowercase($category))[0] OR 0,
	1
]);

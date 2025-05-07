(SELECT
	description,
	name,
	(SELECT
		*,
		record::id(id) AS id,
		(SELECT text, updated FROM $parent.content
		ORDER BY updated)[$].text AS currentContent
	FROM comment
	WHERE type = ["forum", record::id($parent.id)]
	ORDER BY pinned DESC, score DESC
	LIMIT 15 START ($page - 1) * 15) AS posts
FROM forumCategory
WHERE string::lowercase(name) = string::lowercase($category))[0];

math::max([
	(SELECT
		math::ceil(<float> count(
			SELECT 1 FROM comment
			WHERE type = ["forum", record::id($parent.id)]
		) / 15) AS count
	FROM forumCategory 
	WHERE string::lowercase(name) = string::lowercase($category))[0].count OR 0,
	1
]);

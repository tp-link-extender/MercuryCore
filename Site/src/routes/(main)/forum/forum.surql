SELECT
	description,
	(SELECT
		record::id(id) AS id,
		author,
		created,
		fn::currentContent($this.content) AS currentContent
	FROM comment
	WHERE type = ["forum", record::id($parent.id)]
		AND visibility = "Visible"
	ORDER BY created)[$] AS latestPost,
	name,
	count(
		SELECT 1 FROM comment
		WHERE type = ["forum", record::id($parent.id)]
			AND visibility = "Visible"
	) AS postCount
FROM forumCategory;

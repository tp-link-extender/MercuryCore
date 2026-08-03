SELECT
	*,
	record::id(id) AS id,

	fn::currentContent($this.description) AS description,

	array::flatten(
		SELECT VALUE fn::getComments($this.id, 1, $user)
		FROM comment WHERE type = ["asset", record::id($parent.id)]
	) AS comments
FROM $asset;

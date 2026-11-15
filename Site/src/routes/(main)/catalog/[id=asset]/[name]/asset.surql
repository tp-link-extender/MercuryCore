SELECT
	*,
	record::id(id) AS id,

	# package contents are not selected here: the Economy service knows what's inside a package, so the load function adds them as items (the page reads that unconditionally)

	fn::currentContent($this.description) AS description,
	array::flatten(
		SELECT VALUE fn::getComments($this.id, 1, $user) FROM comment WHERE type = ["asset", record::id($parent.id)]
	) AS comments
FROM $asset;
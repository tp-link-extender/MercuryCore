SELECT
	*,
	record::id(id) AS id,

	# package contents, empty for everything else (the page reads this unconditionally) guarded so non-packages never traverse the packageItem relation
	IF type = 32 {
		(SELECT record::id(id) AS id, name, price, type
		FROM $parent->packageItem->asset)
	} ELSE {
		[]
	} AS items,

	fn::currentContent($this.description) AS description,
	array::flatten(
		SELECT VALUE fn::getComments($this.id, 1, $user) FROM comment WHERE type = ["asset", record::id($parent.id)]
	) AS comments
FROM $asset;

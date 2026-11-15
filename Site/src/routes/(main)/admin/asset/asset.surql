SELECT
	record::id(id) AS id,
	name,
	price,
	type,
	(SELECT record::id(id) AS id, name
	FROM $parent->imageAsset->asset)[0] AS imageAsset
FROM asset WHERE visibility = "Pending"
	AND type IN [2, 8, 11, 12, 13, 17, 18, 19];

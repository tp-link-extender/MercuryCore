SELECT
	(SELECT record::id(id) AS id FROM $parent->imageAsset->asset)[0].id AS imageAssetId,
	type,
	name
FROM $asset;

SELECT
	name,
	visibility,
	type,
	(SELECT record::id(id) AS id FROM $parent->imageAsset->asset)[0].id AS imageAssetId
FROM $asset;

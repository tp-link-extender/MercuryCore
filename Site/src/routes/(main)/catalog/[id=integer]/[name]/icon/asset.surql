SELECT
	name,
	visibility,
	type,
	(SELECT meta::id(id) AS id FROM ->imageAsset->asset)[0].id AS imageAssetId
FROM $asset;

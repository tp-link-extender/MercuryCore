SELECT
	*,
	record::id(id) AS id,
	(SELECT record::id(id) AS id FROM $parent->imageAsset->asset)[0].id AS imageAssetId,

	fn::currentContent($this.description) AS description
FROM $asset;

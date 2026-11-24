SELECT
	record::id(id) AS id,
	name,
	price,
	forSale,
	type,
	visibility,
	(SELECT record::id(id) AS id FROM $parent->imageAsset->asset)[0].id AS imageAssetId,

	fn::currentContent($this.description) AS description
FROM $asset;

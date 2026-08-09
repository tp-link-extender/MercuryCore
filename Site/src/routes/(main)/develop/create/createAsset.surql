LET $imageAsset = CREATE ONLY asset CONTENT {
	id: $imageAssetId,
	name: $name,
	type: 1,
	visibility: $visibility,
};

LET $asset = CREATE ONLY asset CONTENT {
	id: $id,
	description: [{
		text: $description,
	}],
	name: $name,
	price: $price,
	type: $assetType,
	visibility: $visibility,
};
RELATE $asset->imageAsset->$imageAsset;

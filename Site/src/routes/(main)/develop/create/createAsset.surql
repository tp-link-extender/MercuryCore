LET $imageAsset = CREATE ONLY asset CONTENT {
	id: $imageAssetId,
	name: $name,
	type: 1,
	visibility: $visibility,
};
RELATE $user->ownsAsset->$imageAsset;
RELATE $user->created->$imageAsset;

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
RELATE $user->ownsAsset->$asset;
RELATE $user->created->$asset;
RELATE $asset->imageAsset->$imageAsset;

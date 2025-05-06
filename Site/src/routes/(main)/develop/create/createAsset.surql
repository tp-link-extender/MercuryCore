LET $imageAsset = CREATE asset CONTENT {
	id: $imageAssetId,
	name: $name,
	type: 1,
};
RELATE $user->owns->$imageAsset;
RELATE $user->created->$imageAsset;

LET $asset = CREATE asset CONTENT {
	id: $id,
	description: [{
		text: $description,
		updated: time::now(),
	}],
	name: $name,
	price: $price,
	type: $assetType,
};
RELATE $user->owns->$asset;
RELATE $user->created->$asset;
RELATE $asset->imageAsset->$imageAsset;

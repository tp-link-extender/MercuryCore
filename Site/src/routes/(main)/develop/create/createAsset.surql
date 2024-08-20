LET $imageAsset = CREATE asset CONTENT {
	id: $imageAssetId,
	name: $name,
	type: 1,
	price: 0,
	description: [],
	created: time::now(),
	updated: time::now(),
	visibility: "Pending",
};
RELATE $user->owns->$imageAsset SET time = time::now();
RELATE $user->created->$imageAsset;

LET $asset = CREATE asset CONTENT {
	id: $id,
	name: $name,
	type: $assetType,
	price: $price,
	description: [{
		text: $description,
		updated: time::now(),
	}],
	created: time::now(),
	updated: time::now(),
	visibility: "Pending",
};
RELATE $user->owns->$asset SET time = time::now();
RELATE $user->created->$asset;
RELATE $asset->imageAsset->$imageAsset;

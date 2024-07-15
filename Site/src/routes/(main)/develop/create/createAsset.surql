LET $id = (UPDATE ONLY stuff:increment SET asset += 1).asset;
LET $imageAsset = CREATE asset CONTENT {
	id: $id,
	name: $name,
	type: 1,
	price: 0,
	description: [],
	created: time::now(),
	updated: time::now(),
	visibility: "Pending",
};
RELATE $user->owns->$imageAsset;
RELATE $user->created->$imageAsset;

LET $id2 = (UPDATE ONLY stuff:increment SET asset += 1).asset;
LET $asset = CREATE asset CONTENT {
	id: $id2,
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
RELATE $user->owns->$asset;
RELATE $user->created->$asset;
RELATE $asset->imageAsset->$imageAsset;
$id; # return the idz
$id2;

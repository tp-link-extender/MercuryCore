LET $asset = CREATE ONLY asset CONTENT {
	description: [{
		text: $description,
		updated: time::now(),
	}],
	name: $name,
	price: $price,
	type: $assetType,
	visibility: "Visible", # admin, immediately visible
};
record::id($asset.id);
RELATE $user->ownsAsset->$asset;
RELATE $user->created->$asset;

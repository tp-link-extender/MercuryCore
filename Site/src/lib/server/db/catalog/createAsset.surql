# The image is only the texture of the item, so it isn't sold on its own
LET $imageAsset = CREATE ONLY asset CONTENT {
	forSale: false,
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

# Lets the caller check that the asset was actually created
RETURN $asset != NONE;
